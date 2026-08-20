locals {
  public_ips = [
    for key, host in alicloud_instance.host :
      try(alicloud_eip.host[key].ip_address, host.public_ip)
  ]
  instance_ids = [
    for h in alicloud_instance.host : h.id
  ]
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

output "ids" {
  value = zipmap(local.hostnames, local.instance_ids)
}
