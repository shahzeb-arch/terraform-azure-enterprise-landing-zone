# Virtual Network (VNet)

## What it is
An Azure Virtual Network — your private, isolated network in Azure. It defines the
address space (CIDR) inside which subnets, VMs, and private endpoints live.

## When to use it (production)
- The backbone of every landing zone (hub VNet + spoke VNets).
- One hub VNet for shared services (firewall, gateway, DNS).
- One spoke VNet per workload, peered to the hub.

## Resources created
- `azurerm_virtual_network`

## Usage example
```hcl
module "virtual_network" {
  source               = "../../modules/networking/virtualNetwork"
  virtual_network_name = "vnet-prod-hub"
  resource_group_name  = "rg-prod-network"
  location             = "East US"
  address_space        = ["10.0.0.0/16"]
  dns_servers          = ["10.0.0.4"] # e.g. custom/firewall DNS
  tags                 = { Environment = "prod" }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| virtual_network_name | VNet name | string | — | yes |
| location | Azure region | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| address_space | List of CIDR blocks | list(string) | — | yes |
| tags | Tags | map(string) | {} | no |
| ddos_protection_plan | Optional DDoS plan {id, enable} | object | null | no |
| encryption | Optional VNet encryption {enforcement} | object | null | no |
| dns_servers | Custom DNS servers | list(string) | [] | no |
| edge_zone | Edge zone | string | null | no |
| flow_timeout_in_minutes | Flow timeout | number | null | no |

## Outputs
| Name | Description |
|---|---|
| resource_id | VNet ID |
| name | VNet name |
| address_space | Assigned address spaces |

## Production notes
- Plan non-overlapping CIDR ranges across all VNets (hub + spokes) up front.
- Point `dns_servers` at your central DNS (often Azure Firewall) for Private DNS.
- Enable DDoS Standard on internet-facing hub VNets.
