/* DERIVED --------------------------------------*/

locals {
  stage  = var.stage != "" ? var.stage : terraform.workspace
  tokens = split(".", local.stage)
  dc     = "${var.provider_name}-${var.zone}"
  /* convert ports to port ranges, as requried by port_range argument */
  tcp_ports = [
    for port in var.open_tcp_ports :
    (replace(port, "-", "/") != port ? replace(port, "-", "/") : "${port}/${port}")
  ]
  udp_ports = [
    for port in var.open_udp_ports :
    (replace(port, "-", "/") != port ? replace(port, "-", "/") : "${port}/${port}")
  ]
  /* always add SSH, WireGuard, and Consul to allowed ports */
  open_tcp_ports = concat(["22/22", "8301/8301"], local.tcp_ports)
  open_udp_ports = concat(["51820/51820", "8301/8301"], local.udp_ports)
  /* pre-generated list of hostnames */
  hostnames = [for i in range(1, var.host_count + 1) :
    "${var.name}-${format("%02d", i)}.${local.dc}.${var.env}.${local.stage}"
  ]
}

/* RESOURCES ------------------------------------*/

resource "alicloud_security_group" "host" {
  name        = "sg-${var.env}-${local.stage}"
  description = "Sec Group via Terraform"
  vpc_id      = data.alicloud_vpcs.host.vpcs[0].id
}

/* WARNING: Using 'all' protocol fucks with port_range option */
resource "alicloud_security_group_rule" "icmp" {
  security_group_id = alicloud_security_group.host.id
  type              = "ingress"
  ip_protocol       = "icmp"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "tcp" {
  for_each = toset(local.open_tcp_ports)

  security_group_id = alicloud_security_group.host.id
  type              = "ingress"
  ip_protocol       = "tcp"
  cidr_ip           = "0.0.0.0/0"
  port_range        = replace(each.key, "-", "/")
}

resource "alicloud_security_group_rule" "udp" {
  for_each = toset(local.open_udp_ports)

  security_group_id = alicloud_security_group.host.id
  type              = "ingress"
  ip_protocol       = "udp"
  cidr_ip           = "0.0.0.0/0"
  port_range        = replace(each.key, "-", "/")
}

resource "alicloud_security_group_rule" "blocked_ips" {
  for_each = toset(var.blocked_ips)

  security_group_id = alicloud_security_group.host.id
  type              = "ingress"
  ip_protocol       = "all"
  cidr_ip           = each.key
}

/* default vpc to avoid creating by hand */
data "alicloud_vpcs" "host" {
  is_default = true
}

/* default vswitch to avoid creating by hand */
data "alicloud_vswitches" "host" {
  is_default = true
}

data "alicloud_images" "host" {
  name_regex = var.image_regex
}

resource "alicloud_instance" "host" {
  for_each = toset(local.hostnames)

  host_name     = each.key
  instance_name = each.key

  security_groups = [alicloud_security_group.host.id]
  image_id        = data.alicloud_images.host.images[0].id
  vswitch_id      = data.alicloud_vswitches.host.vswitches[0].id

  tags = {
    stage = local.stage
    group = var.group
    env   = var.env
  }

  key_name             = var.key_pair
  instance_type        = var.type
  system_disk_category = var.disk

  /* Ignore changes to disk image */
  lifecycle {
    ignore_changes = [image_id, key_name]
  }

  /* costs */
  instance_charge_type = var.charge
  period_unit          = var.period
  /* NOTE: We provision inside Elastic IP association */
}

/* Optional resource when data_vol_size is set */
resource "alicloud_disk" "host" {
  for_each = toset([ for h in local.hostnames : h if var.data_vol_size > 0 ])

  disk_name   = "data.${each.key}"
  description = "Extra data volume created by Terraform."
  category    = "cloud_ssd"

  size    = var.data_vol_size
  zone_id = data.alicloud_vswitches.host.vswitches[0].zone_id

  tags = {
    stage = local.stage
    group = var.group
    env   = var.env
  }
}

resource "alicloud_disk_attachment" "host" {
  for_each = { for k,v in alicloud_instance.host : k => v if var.data_vol_size > 0 }

  disk_id     = alicloud_disk.host[each.key].id
  instance_id = each.value.id
}

resource "alicloud_eip" "host" {
  for_each = alicloud_instance.host

  bandwidth = var.max_band_out

  lifecycle {
    prevent_destroy = true
  }
}

resource "alicloud_eip_association" "host" {
  for_each = alicloud_instance.host

  allocation_id = alicloud_eip.host[each.key].id
  instance_id   = each.value.id
}

resource "null_resource" "host" {
  for_each = alicloud_instance.host

  /* Trigger bootstrapping on host or public IP change. */
  triggers = {
    instance_id = each.value.id
    eip_id = alicloud_eip.host[each.key].id
  }

  /* Make sure everything is in place before bootstrapping. */
  depends_on = [
    alicloud_instance.host,
    alicloud_disk.host,
    alicloud_disk_attachment.host,
    alicloud_eip.host,
    alicloud_eip_association.host
  ]

  /* It is necessary to provision here instead of in alicloud_instance
   * because Alibaba Cloud instances do not have public IPs by default */
  provisioner "ansible" {
    connection {
      host = alicloud_eip.host[each.key].ip_address
      user = var.ssh_user
    }

    plays {
      playbook {
        file_path = "${path.cwd}/ansible/bootstrap.yml"
      }

      hosts  = [each.value.public_ip]
      groups = [var.group]

      extra_vars = {
        hostname         = each.value.host_name
        ansible_ssh_user = var.ssh_user
        data_center      = local.dc
        stage            = local.stage
        env              = var.env
      }
    }
  }
}

resource "cloudflare_record" "host" {
  for_each = alicloud_eip.host

  zone_id = var.cf_zone_id
  name    = each.key
  value   = each.value.ip_address
  type    = "A"
  ttl     = 3600
}

resource "ansible_host" "host" {
  for_each = alicloud_instance.host

  inventory_hostname = each.key

  groups = ["${var.env}.${local.stage}", var.group, local.dc]

  vars = {
    ansible_host = alicloud_eip.host[each.key].ip_address
    hostname     = each.key
    region       = each.value.availability_zone
    dns_entry    = "${each.key}.${var.domain}"
    dns_domain   = var.domain
    data_center  = local.dc
    stage        = local.stage
    env          = var.env
  }
}
