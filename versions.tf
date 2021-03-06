
terraform {
  required_version = "~> 1.0.0"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = " = 1.124.3"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.21.0"
    }
    ansible = {
      source  = "nbering/ansible"
      version = " = 1.0.4"
    }
  }
}
