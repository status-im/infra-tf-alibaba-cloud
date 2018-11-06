output "public_ips" {
  value = ["${alicloud_instance.host.*.public_ip}"]
}

output "hostnames" {
  value = ["${alicloud_instance.host.*.host_name}"]
}
