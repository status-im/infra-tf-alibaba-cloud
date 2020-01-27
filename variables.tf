/* DNS ------------------------------------------*/

variable "cf_zone_id" {
  description = "ID of CloudFlare zone for host record."
  /* We default to: statusim.net */
  default     = "14660d10344c9898521c4ba49789f563"
}

/* SCALING --------------------------------------*/

variable "host_count" {
  description = "Number of instances to start in this region."
}

variable "image" {
  /**
   * This image is created with Packer because Alicloud does not provide one
   * See: https://github.com/status-im/infra-utils/tree/master/alicloud/ubuntu_1804
   */
  description = "OS image used to create instance."
  default     = "ubuntu_18_04_64_custom_20180719"
}

variable "type" {
  description = "Type of instance to create."
  default     = "ecs.t5-lc2m1.nano"
}

variable "zone" {
  description = "Availability Zone in which the instance will be created."
  default     = "cn-hongkong-c"
}

variable "disk" {
  description = "Disk I/O optimization type."
  default     = "cloud_ssd"
}

variable "max_band_out" {
  description = "Maximum outgoing bandwidth to the public network, measured in Mbps."
  default     = 50
}

variable "vol_size" {
  description = "Size in GiB of an extra Volume to attach to the instance."
  default     = 0
}

/* GENERAL --------------------------------------*/

variable "provider_name" {
  description = "Short name of provider being used."

  /* Digital Ocean */
  default = "ac"
}

variable "name" {
  description = "Prefix of hostname before index."
  default     = "node"
}

variable "charge" {
  description = "Way in which the instance is paid for."

  /* The other value is PrePaid */
  default = "PostPaid"
}

variable "period" {
  description = "Time period in which we pay for instances."

  /* The other value is Week */
  default = "Month"
}

variable "group" {
  description = "Name of Ansible group to add hosts to."
}

variable "env" {
  description = "Environment for these hosts, affects DNS entries."
}

variable "domain" {
  description = "DNS Domain to update"
}

variable "ssh_user" {
  description = "SSH user used to log in after creation."
  default     = "root"
}

variable "key_pair" {
  description = "SSH key pair used to log in to instance"

  /* WARNING I really shouldn't use my own key here */
  default = "jakub_status.im"
}

/* FIREWALL -------------------------------------*/

variable "open_tcp_ports" {
  description = "TCP ports to enable access to through security group."
  type        = list(string)
  default     = []
}

variable "open_udp_ports" {
  description = "UDP ports to enable access to through security group."
  type        = list(string)
  default     = []
}

/* See: https://www.terraform.io/docs/providers/alicloud/d/security_group_rules.html */
variable "blocked_ips" {
  description = "List of source IP ranges for which we want to block access."
  type        = list(string)
  default     = []
}
