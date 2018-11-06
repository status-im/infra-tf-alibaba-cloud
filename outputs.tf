locals = {
  public_ips = "${alicloud_instance.host.*.public_ip}"
  hostnames  = "${alicloud_instance.host.*.host_name}"
}

output "public_ips" {
  value = ["${local.public_ips}"]
}

output "hostnames" {
  value = ["${local.hostnames}"]
}

output "hosts" {
  value = ["${zipmap(local.hostnames, local.public_ips)}"]
}
