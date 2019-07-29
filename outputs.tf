locals {
  public_ips = alicloud_eip.host.*.ip_address
  hostnames  = alicloud_instance.host.*.host_name
}

output "public_ips" {
  value = local.public_ips
}

output "hostnames" {
  value = local.hostnames
}

output "hosts" {
  value = zipmap(local.hostnames, local.public_ips)
}

