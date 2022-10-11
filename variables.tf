/* DNS ------------------------------------------*/

variable "cf_zone_id" {
  description = "ID of CloudFlare zone for host record."
  type        = string
  default     = "14660d10344c9898521c4ba49789f563" /* statusim.net */
}

/* SCALING --------------------------------------*/

variable "host_count" {
  description = "Number of instances to start in this region."
  type        = number
}

variable "image_regex" {
  description = "Regex for OS image used to create instance."
  type        = string
  default     = "ubuntu_22_04_x64_20G_alibase_.*.vhd"
  /* cmd: `aliyun ecs DescribeImages --output 'cols=ImageName' 'rows=Images.Image[]' --pager --ImageName='ubuntu*'` */
}

variable "type" {
  description = "Type of instance to create."
  type        = string
  default     = "ecs.t5-lc2m1.nano"
}

variable "zone" {
  description = "Availability Zone in which the instance will be created."
  type        = string
  default     = "cn-hongkong-c"
}

variable "root_vol_size" {
  description = "Size of the root volume."
  type        = number
  default     = 10 /* 0 should default to size of base image */
}

variable "root_vol_type" {
  description = "I/O optimization type of root volume."
  type        = string
  default     = "cloud_ssd"
}

variable "data_vol_size" {
  description = "Size in GiB of an extra data volume to attach to the instance."
  type        = number
  default     = 0
}

variable "data_vol_type" {
  description = "I/O optimization type of extra data volume."
  type        = string
  default     = "cloud_efficiency"
}

variable "max_band_out" {
  description = "Maximum outgoing bandwidth to the public network, measured in Mbps."
  type        = number
  default     = 50
}

/* GENERAL --------------------------------------*/

variable "provider_name" {
  description = "Short name of provider being used."
  type        = string
  default     = "ac" /* Alibaba Cloud */
}

variable "name" {
  description = "Prefix of hostname before index."
  type        = string
  default     = "node"
}

variable "charge" {
  description = "Way in which the instance is paid for."
  type        = string
  default     = "PostPaid" /* Other: PrePaid */
}

variable "period" {
  description = "Time period in which we pay for instances."
  type        = string
  default     = "Month" /* Other: Week */
}

variable "group" {
  description = "Name of Ansible group to add hosts to."
  type        = string
}

variable "env" {
  description = "Environment for these hosts, affects DNS entries."
  type        = string
}

variable "stage" {
  description = "Name of stage, like prod, dev, or staging."
  type        = string
  default     = ""
}

variable "domain" {
  description = "DNS Domain to update"
  type        = string
}

variable "ssh_user" {
  description = "SSH user used to log in after creation."
  type        = string
  default     = "root"
}

variable "key_pair" {
  description = "SSH key pair used to log in to instance"
  type        = string
  default     = "jakub_status.im" /* TODO: I really shouldn't use my own key here */
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

variable "blocked_ips" {
  description = "List of source IP ranges for which we want to block access."
  type        = list(string)
  default     = []
  /* https://www.terraform.io/docs/providers/alicloud/d/security_group_rules.html */
}
