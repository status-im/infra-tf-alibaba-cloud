/* DERIVED --------------------------------------*/
locals {
  stage      = "${terraform.workspace}"
  tokens     = "${split(".", local.stage)}"
  dc         = "${var.provider}-${var.zone}"
  /* always add SSH, Tinc, Netdata, and Consul to allowed ports */
  open_ports = [
    "22/22", "655/655", "8000/8000", "8301/8301",
    "${var.open_ports}",
  ]
}
/* RESOURCES ------------------------------------*/

/* default vpc to avoid creating by hand */
data "alicloud_vpcs" "host" {
  is_default = true
}
/* default vswitch to avoid creating by hand */
data "alicloud_vswitches" "host" {
  is_default = true
}

resource "alicloud_security_group" "host" {
  name        = "sg-${var.env}-${local.stage}"
  description = "Sec Group via Terraform"
  vpc_id      = "${data.alicloud_vpcs.host.vpcs.0.id}"
}

resource "alicloud_security_group_rule" "host_tcp" {
  security_group_id = "${alicloud_security_group.host.id}"
  type              = "ingress"
  ip_protocol       = "tcp"
  cidr_ip           = "0.0.0.0/0"
  port_range        = "${replace(element(local.open_ports, count.index), "-", "/")}"
  count             = "${length(local.open_ports)}"
}

data "alicloud_images" "host" {
  owners = "self"
  name_regex = "${var.image}"
}

resource "alicloud_instance" "host" {
  host_name       = "${var.name}-${format("%02d", count.index+1)}.${local.dc}.${var.env}.${local.stage}"
  instance_name   = "${var.name}-${format("%02d", count.index+1)}.${local.dc}.${var.env}.${local.stage}"

  security_groups = ["${alicloud_security_group.host.id}"]
  image_id        = "${data.alicloud_images.host.images.0.id}"
  vswitch_id      = "${data.alicloud_vswitches.host.vswitches.0.id}"

  tags = {
    stage = "${local.stage}"
  	group = "${var.group}"
  	env   = "${var.env}"
  }

  key_name                   = "${var.key_pair}"
  availability_zone          = "${var.zone}"
  instance_type              = "${var.type}"
  system_disk_category       = "${var.disk}"
  count                      = "${var.count}"
  internet_max_bandwidth_out = "${var.max_band_out}"

  /* costs */
  instance_charge_type       = "${var.charge}"
  period_unit                = "${var.period}"

  /* necessary because alicloud does not provide it */
  /* https://github.com/radekg/terraform-provisioner-ansible/issues/54 */
  connection {
    host = "${self.public_ip}"
  }

  /* bootstraping access for later Ansible use */
  provisioner "ansible" {
    plays {
      playbook = {
        file_path = "${path.cwd}/ansible/bootstrap.yml"
      }
      groups   = ["${var.group}"]
      extra_vars = {
        hostname         = "${var.name}-${format("%02d", count.index+1)}.${local.dc}.${var.env}.${local.stage}"
        ansible_ssh_user = "${var.ssh_user}"
        data_center      = "${local.dc}"
        stage            = "${local.stage}"
        env              = "${var.env}"
      }
    }
  }
}

resource "cloudflare_record" "host" {
  domain = "${var.domain}"
  count  = "${var.count}"
  name   = "${element(alicloud_instance.host.*.host_name, count.index)}"
  value  = "${element(alicloud_instance.host.*.public_ip, count.index)}"
  type   = "A"
  ttl    = 3600
}

resource "ansible_host" "host" {
  inventory_hostname = "${element(alicloud_instance.host.*.host_name, count.index)}"
  groups = ["${var.group}", "${local.dc}"]
  count = "${var.count}"
  vars {
    ansible_host = "${element(alicloud_instance.host.*.public_ip, count.index)}"
    hostname     = "${element(alicloud_instance.host.*.host_name, count.index)}"
    region       = "${element(alicloud_instance.host.*.availability_zone, count.index)}"
    dns_entry    = "${element(alicloud_instance.host.*.host_name, count.index)}.${var.domain}"
    dns_domain   = "${var.domain}"
    data_center  = "${local.dc}"
    stage        = "${local.stage}"
    env          = "${var.env}"
  }
}
