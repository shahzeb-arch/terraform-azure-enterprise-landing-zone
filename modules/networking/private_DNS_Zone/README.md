# Private DNS Zone

## What it is
A Private DNS Zone provides name resolution for resources **inside** your VNets
without exposing records to the public internet. Essential for Private Endpoints.

## When to use it (production)
- One zone per Azure service you use with Private Endpoints, e.g.
  `privatelink.blob.core.windows.net`, `privatelink.vaultcore.azure.net`,
  `privatelink.database.windows.net`.
- Centralised in the hub / connectivity subscription, linked to all spokes.

## Resources created
- `azurerm_private_dns_zone`

(Link it to VNets using the `private_DNS_vnet_link` module.)

## Usage example
```hcl
module "private_dns_zone" {
  source                = "../../modules/networking/private_DNS_Zone"
  private_dns_zone_name = "privatelink.blob.core.windows.net"
  resource_group_name   = "rg-prod-dns"
  tags                  = { Environment = "prod" }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| private_dns_zone_name | Zone name (privatelink.* for PE) | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| soa_record | Optional SOA record settings | object | null | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | Private DNS Zone ID |
| name | Private DNS Zone name |

## Production notes
- The zone name MUST match Azure's `privatelink.*` schema for the service, or the
  Private Endpoint connection silently won't resolve.
- Manage these centrally and link every spoke VNet; pair with Azure Policy to
  auto-create PE DNS records.
