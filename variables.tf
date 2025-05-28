/* DNS ------------------------------------------*/

variable "cf_zone_id" {
  description = "ID of CloudFlare zone for host record."
  type        = string
  default     = "fd48f427e99bbe1b52105351260690d1"
}

variable "domain" {
  description = "DNS Domain to update"
  type        = string
  default     = "status.im"
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
  default     = 20 /* 0 should default to size of base image */
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

variable "ssh_user" {
  description = "SSH user used to log in after creation."
  type        = string
  default     = "root"
}

variable "ssh_keys" {
  description = "Names of ssh public keys to add to root user of created hosts"
  type        = list(string)
  default = [
    # jakub@status.im
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeWB4SeXQfEsfkNPOkSLoTQ/7VDpf8CsaRQ+waCHEEv4v2fFc/9lMbQ6Z208UEQKJMOMdtwd3eB7j6aFIirMQTYcm/NuxPLdRRnlxLNJIVMBfKUV5V3OkbneqzBTEvtAaIDC506kIlXxAPfZCDVxzAi7B+NkHUvhjCEjScM2KfamahDZUbj2ww2Q/82P1Qj8QY/1b2wC6OXBnKPUQIzAzrxDNYWaXdB/4DysDcib50kd2URenpMVU1DCjSWXBniSnpEVh0Lxjehsnfg+oE3BP3u6wA+1xufukH9h9eQ/hTM1PXEVC2ObpgESRYxc3rqkqVxYbOzrmCRVJpvKoGs+W89vIoFUt6/tzunAMogo2VHhT7LnGE4iizj9YODxIdpRMGGeMgZiceoOuNFAjKg8Qay4aoE50uklim4ircOXgrAasRotUcz28EU5oaV9/NO+GKNzooRNBX2U/c1MsTI+6mz7ppMq0NCHOpO5sY1qC8F2lZbDDGQgC25btqu+xnbqHwCDSst2Sy5yvF3C34F/Xt8kw3zkraB1OmTWwW/QIA+o3AViaA59r+ZicIIEWvUbUbcMD/GFDesOgzK8V9G6kZNuQoEVsq9FHEMTpsGSBDOIHn4aWP+7gQK2FhvyXBGj/z/NDFY1H+I2KvhI0rkV3NaTtUy0+51uKO5Efnx8cQyw== jakub@status.im",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5NIT2SVFFjV+ZraPBES45z8wkJf769P7AXdZ4FiJw+DcXKawNJCUefeBQY5GVofVOzOHUrkYLqzxVJihIZJaDgeyME/4pLXYztkk9EOWdQSadxLJjWItMJULJrh5nnXzKxv5yy1SGJCTcMSXrvR6JRduu+KTHGncXJ2Ze6Bdgm63sOdfyPCITSC+nc4GexYLAQmBxXCwtKieqfWVmKpazlVDxAg3Q1h2UXOuLTjkWomvzVCggwhzHtN/STQMCH49PlW/VoIBlrpYqlmRGObsdBae4Bk/D5ZpisJi6w573RcF9q3VrqJTHLiSpntfVJEtsbmyiNNckIujQfRk2KYvSCK2iGP17hfCE9HmEfSZNWrKrMqKJ7gHOhXHJrszh6TtN9zmgomPvYolJBLz/2/JC8swfixHPMzxQa+P2NyqC0yWg8Xqd1JLWKLHsLwpEYvmOfyYIY8zOfk7y3OJX8h7D/fgbnG/V75EVuZDc8sqXTJpj3esoEsz8XVu9cVraAOodG4zYKFnoTomAzBJtImh6ghSEDGT5BAvDyFySyJGMibCsG5DwaLvZUcijEkKke7Z7OoJR4qp0JABhbFn0efd/XGo2ZyGtJsibSW7ugayibEK7bDaYAW3lNXgpcDqpBiDcJVQG/UhhCSSrTsG0IUSbvSsrDuF6gCJWVKt4+klvLw== jakub@status.im",
    # alexis@status.im
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHb8ORNUIJkwUACMl59CvbqJJ2dFVL2QYDtJhAgehKRQSW87nU2GtAc/23ncC7BsDJMolAare3gDODpcfxlDcrHOG6O9FQmakEY0AMRO0Wk4uJHRCCPjxyYLoRUNKOUjmpY6JEG+ZzKjRGqMcvH19PmzUOkR2thdJBJ8tluXEk/UraFoSJUcA8dRxou2o9jdLtTPJIRyZNkhiRXrnD+8rD6a+VqM2JWqTqg/Mgj6EaZHyXcg2xAtXHEbVl5MIAbWPwCz2DjVNp52dEe3GyUFdlFr8Rp7TVPfA8qe+hbrs2V+ubdgEAFxQBfsSoY9UPjhdO8Yl3nhqNvXOKRTQ+EJLdlGobJUG2blrAyleyREomSixOIf6LM6HwdRxPz1QzGf8kKvqyIWtzR/s7xoV3ELLTzxyrUZF9yLrRYbdlqnxIKErb6lrwB3WUIAaT7ZQdJpRZvM5kNPg3Z2ZQZzs7SdQ/d3N4CYptr+mXHOze2cazE6DYyCshk9E4C70pBMejfaRM8RCjky6jDkODNKvu9sJXtKHyX7QceSnK83jPE/1taDLhOfFxezcqSNATtATENd8D6ulTTxflWU+cxfsCEoAUIaat5ORINYFsLlxdf3VUAKZNNmWiEB7cWKzdXbiRuqSpTAyuIxdFpFCe3GrM2R+LunsEmx/qWsDyhYjU0t7C7w== alexis@status.im",
    # anton@status.im
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWR0sBIp/KRFxbJgYKFSSuk2vKANZwxmina7Y96KN7U3kqz5Gulkm6VhbR1sNYigTYSmnSZz96BKxdBAFy4k63zMzu2IK68QmgD7fevIOuNXaGdlGhA1zYYUF1uKyLUHnzvdmaP6M3x+xXIZT1ftfvPRHCJcrjIyp8JLbYvB+Qo6Gxr/FY7imXH0jJmOh60yfv0XGy0L+8jriR4Lr8xfzkany1qQH4GgatjhLaVWSfbTbNypbsnFeB3GXFQqSpY6ESk/FoSYB1LFyTWx+sAW8fyHdAcBljBczELqbJ8JDiO8FFT0iLFOVEm0Z8QzZOC6Ii3HWAs9+pGhGktoL6qLpIziYA8e3uPYNdXQRqwqnkDnRsduwKgmrX05QPgE0DQaoWpS4nqsBfD5a7FmBE79+8SztUlJ/tNVatDjy25fA2etTPmq+3fxjty9CDqRG49xFswaUSyGpabTb6pTcnSVCnJSj3PhCsRvEBn2OyR+alCTKvMYeueH/eQigjzh16Lu0ylDzeGidmA3AoOQHI+zQsATzCPUq2DkCdQUp+wvoezKOsodlnJ7lomAalkmFFLdYrYewRah3JzirAiFAtBZDpB+IdpPFigAhWq2DdEh7/a14M2dHKqkmjdJvRVRgQ3UfG6PG21lWljRMCxNaAqqsLFKLsR+IQBu3I2ceSraxXoQ== yakimant@gmail.com",
    "no-touch-required sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJXqUxcqsY1U4xG1WlRS0WCaFHeF1MXp3wWhCPuW+b2rAAAADHNzaDpuby10b3VjaA== yakimant@gmail.com",
    # marko@status.im
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2kD/iiRO/tXHo17Rj8r+BytNOUX7S/9VexcYPag/nyqiWn7Ti6A4rxc608C4taj4QpxX1kyPXhD1vdUeyA2eWulStnrDVI4ULhjb29MnVc6k9q5U4rXnuao5ksOjez3VIG0sITGFPGmr+jIlHQZLnpatdSrmh+uj3LSnPerOH7HeHBI4F9ATCtYDdW1xqStwogiaJXVNHX6lxhK/9TlPcpdkY4LbfUdQe48DjdAdN3rFnIAj8iTGL55e0bKQQRw+iqr3OyC/IGeQAPZXBsWSmJX4mIgadaf2Lo0dK4S5RbP2yOsG6eo07eZJq2bYbMoSuCpeYynNUgXF1bXBVSD0z1iC05v25sqyz6HsB843l4F6NEZnUp+DDpemWsZCCWfjouEKCMe91OmYpIt/hOLWumh/oyuSJG9kPCRQmHj5eCxcoxDPrAthJ2XM45WqKCRo7SGdXlEEhrA4iAf2874Io6fERd++bzUVtPyPF77Cgmhs3D/3TSwuUEA3T8Z1bbGU2YWf153B7Haqme3zkqswRKca5LuQ33F5eXxN/xyCEVsNiTt7F68XteNV7eAcZ5vZZ7k29iZk7iVIIJawF1ydS+5Irr79sVLIvhkzm524xGxysspSGCoI4AABYEPlNQkyfnMLtGKMpPRkAEdO1QplaalHPDP6MHIysVRGGiLZV4w== openpgp:0xCC75A7BC",
    # vedran@status.im
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUkd5oWFh9frITLAV05ORpFts790ZQKPYbPBa3fGszbi0y0O3NfA1qURp0AgQFE2u/qRko/vIFDp6fBjjaPsYjygYZNcYRG9rBMmnyp7EH+4Gu3yRsiJabuIP3QIfY/aeMVFijlW/Yw67SvixB88xptHoiHT24Lvrw/nvjk8kumo7dN0YPnvjFIK3Ow/s2dZavPsi4FDJoOfuEgxj4YMysg8YLhNyawd2e58BzG4p6Fo7tRuvXmipTIkYDyA+QvmVSrSRgnS3S1u7vITYymdtIMYtmmvaKaVGT6p6xr+SFkfd1L5WgF8fwcbXKIsgSAKBPEDPJOZX1Fg2GSYIthn7XORLiKi94ZCCYmYczTtxaGpFJBpd+NugWzQYwB4kS/ZwnfcuiTO1SLCB7tVfHTs/CWJwFSKLv1Sncqwi891TDEwShH4x6kIQ8dQZ1JcIBUHeugxzPU8qtkhdpaGjhKCw7oXX24kiwIgJlx+V4hW1IegWDK+HMZDD2w7W+72QTFGXQlE2To+dNs5WdGEe+R+GeyxHiUd+lhJfjYIFbylabFiz3Oo9iNvFLcSwoBmxgge42qo5wcK+59NlmJKEuU+kkkWQ3iVHyPoxnAYtEYa/5UbZ5kNPwKF8X4zv4bKAwW5pXY1flMRmEn4CWJJYfEYJ7Kil9lVu9KYWG13OqHD0IXQ== openpgp:0x52CE8EAE",
    # siddarth@status.im
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcwtypZ77FCnIujrgX5xzUu3NDkXEzg8GD5w1rtMyJx2u5GBXP2QA6/faRanmM2Ach5WspDKj+l+7eHLEJaCN4AS6VI6KvtLypgBYreqIAqO807aAEEu4uCNQQgdTaAItSG/nT0KX0JOC1EHhJSgxAbqvVPKt8Ra0U07qrTykcp9aCIu67cqoCDsp0/sDVyUYWCL8Ue/AoHMOCKWXTktsKRbBodUuG0y/E1CdN+zSX3WdlQtxGsPYp3Z2Vw2e8HAL7Q1Uvlh6bD0G+7KZBKWkZ1C7Yg31QU40o1Sp0uK3tHWNeX9lwKMCOWOhjrFvd6POrj2pmvfcVbqSjFkYNRSzFeKvq624b2j1ZUJg8W7zf+Ylho2C++PHFJxXuG+iWGbllOVtxde8UTh/qOI+aE+0C9I5VfJ0OMEzxWGfwMo4CNX5yICOoNYIGFh+yp3AOifoo74R8/58PgSMVaWWy2a94lnIq42qRLgDJa8WVmpg1r/IKXkdVPRzFI50qOitH5LpTPkndTYix2IEan5Uq4xRQB/6MSLq+8uu9uzm0sej/cD1SjLqLpBritVZ1el2GJFyunW+XIIyrEG+K3AIuvvhI2+LmIPqtHoDdS8LitiFaXoVpgZsJzR5CGqNlqO5BR+GjudizzkCzXJ36yo4yNiCJo8kGxboNfC9rQ2PAebq6Zw== siddarth@status.im",
  ]
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
