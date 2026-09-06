# Subnet

## What it is
A subnet is a segment of a VNet's address space. Resources (VMs, NICs, private
endpoints, gateways) are placed into subnets, and security is applied per subnet.

## When to use it (production)
- Segment workloads by tier: `snet-web`, `snet-app`, `snet-data`.
- Dedicated subnets for special services: `AzureBastionSubnet`,
  `GatewaySubnet`, `AzureFirewallSubnet` (exact names required by Azure).
- Delegated subnets for PaaS (e.g. App Service, AKS, SQL MI).

## Resources created
- `azurerm_subnet`

## Usage example
```hcl
module "subnet" {
  source               = "../../modules/networking/subnet"
  subnet_name          = "snet-app"
  resource_group_name  = "rg-prod-network"
  virtual_network_name = "vnet-prod-spoke"
  address_prefixes     = ["10.1.1.0/24"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| subnet_name | Subnet name | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| virtual_network_name | Parent VNet name | string | — | yes |
| address_prefixes | CIDR(s) for the subnet | list(string) | — | yes |
| service_endpoints | Service endpoints | list(string) | [] | no |
| delegation | Subnet delegation {name, service_name, service_actions} | object | null | no |
| default_outbound_access_enabled | Default outbound internet | bool | true | no |
| private_endpoint_network_policies | PE network policies | string | "Enabled" | no |
| private_link_service_network_policies_enabled | PL service policies | bool | true | no |
| service_endpoint_policy_ids | SE policy IDs | list(string) | [] | no |
| timeouts | Operation timeouts | object | null | no |

## Outputs
| Name | Description |
|---|---|
| id | Subnet ID |
| name | Subnet name |
| address_prefixes | Assigned prefixes |

## Production notes
- Set `private_endpoint_network_policies = "Disabled"` on subnets that host
  Private Endpoints (otherwise PE creation is blocked).
- Special subnets must use Azure's reserved names exactly.
- Size subnets generously — resizing in place is painful once resources exist.
