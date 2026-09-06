# Network Interface (NIC)

## What it is
A NIC connects a virtual machine to a subnet, giving it a private IP (and
optionally a public IP). VMs attach one or more NICs.

## When to use it (production)
- Created for every standalone VM (Linux/Windows). VMSS manages its own NICs.
- Attach to the correct workload subnet; optionally bind a public IP (rare in ELZ).

## Resources created
- `azurerm_network_interface`

## Usage example
```hcl
module "network_interface" {
  source              = "../../modules/compute/networkInterface"
  name                = "nic-app-01"
  resource_group_name = "rg-prod-app"
  location            = "East US"
  ip_configuration = {
    name                          = "ipconfig1"
    subnet_id                     = module.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | NIC name | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| location | Azure region | string | — | yes |
| ip_configuration | {name, subnet_id, allocation, private_ip, public_ip_id} | object | — | yes |
| accelerated_networking_enabled | Enable accelerated networking | bool | false | no |
| dns_servers | Custom DNS servers | list(string) | [] | no |
| internal_dns_name_label | Internal DNS label | string | null | no |
| ip_forwarding_enabled | Enable IP forwarding | bool | false | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | NIC ID |
| name | NIC name |
| private_ip_address | Assigned private IP |

## Production notes
- Enable accelerated networking on supported VM sizes for lower latency.
- Avoid public IPs on NICs in an ELZ — use Bastion + NAT Gateway / Load Balancer.
