# NAT Gateway

## What it is
A NAT Gateway provides reliable, scalable **outbound-only** internet connectivity
for resources in a subnet, using one or more static public IPs (SNAT).

## When to use it (production)
- Give private VMs/AKS outbound internet without exposing inbound public IPs.
- Avoid SNAT port exhaustion that happens with default outbound or LB outbound.

## Resources created
- `azurerm_nat_gateway`

(Associate it to a subnet + public IP using the `nat_association` module.)

## Usage example
```hcl
module "nat_gateway" {
  source                  = "../../modules/networking/nat_gateway"
  nat_gateway_name        = "natgw-prod"
  resource_group_name     = "rg-prod-network"
  location                = "East US"
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| nat_gateway_name | NAT Gateway name | string | — | yes |
| location | Azure region | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| sku_name | SKU (Standard) | string | "Standard" | no |
| idle_timeout_in_minutes | Idle timeout (4-120) | number | 10 | no |
| zones | Availability zones | list(string) | ["1"] | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | NAT Gateway ID |
| name | NAT Gateway name |
| resource_guid | NAT Gateway resource GUID |

## Production notes
- NAT Gateway is zonal — for multi-zone HA, deploy one per zone.
- Attach a dedicated Standard Public IP (or IP prefix for more SNAT ports).
- Preferred over LB outbound rules for predictable, scalable egress.
