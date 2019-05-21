# Description

This is a helper module used by Status internal repos like: [infra-hq](https://github.com/status-im/infra-hq), [infra-misc](https://github.com/status-im/infra-misc), [infra-eth-cluster](https://github.com/status-im/infra-eth-cluster), or [infra-swarm](https://github.com/status-im/infra-swarm).

# Usage

Simply import the modue using the `source` directive:
```hcl
module "alibaba-cloud" {
  source = "github.com/status-im/infra-tf-alibaba-cloud"
}
```

[More details.](https://www.terraform.io/docs/modules/sources.html#github)

# Variables

* __Scaling__
  * `count` - Number of hosts to start in this zone.
  * `image` - OS image used to create host. (default: `ubuntu_18_04_64_custom_20180719`)
  * `type` - Type of machine to deploy. (default: `ecs.t5-lc2m1.nano`)
  * `zone` - Specific zone in which to deploy hosts. (default: `cn-hongkong-c`)
  * `max_band_out` - Maximum outgoing bandwidth to the public network, measured in Mbps. (default: `30`)
  * `vol_size` - Size in GiB of an extra Volume to attach to the instance. (default: 0)
* __Billing__
  * `charge` - Way in which the instance is paid for. (default: `PostPaid`)
  * `period` - Time period in which we pay for instances. (default: `Month`)
* __General__
  * `name` - Prefix of hostname before index. (default: `node`)
  * `group` - Name of Ansible group to add hosts to.
  * `env` - Environment for these hosts, affects DNS entries.
  * `domain` - DNS Domain to update.
* __Security__
  * `ssh_user` - User used to log in to instance (default: `root`)
  * `key_pair` - SSH key pair used to log in to instance. (default: `jakub_status.im`)
  * `open_ports` - Port ranges to enable access from outside. Format: `N-N` (default: `[]`)
  * `blocked_ips` - List of blocked IP ranges. Format: [CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) (default: `[]`)
