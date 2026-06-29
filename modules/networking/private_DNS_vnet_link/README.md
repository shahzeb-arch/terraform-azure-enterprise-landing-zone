# Private DNS Zone — Virtual Network Link

## What it is
Links a Private DNS Zone to a VNet so resources in that VNet can resolve the
zone's records. A zone is useless to a VNet until it is linked.

## When to use it (production)
- Link each spoke (and the hub) VNet to every centralised `privatelink.*` zone.
- Enable `registration_enabled` only on the one VNet that should auto-register
  its VM records (usually false for privatelink zones).

## Resources created
- `azurerm_private_dns_zone_virtual_network_link`

## Usage example
```hcl
module "private_dns_vnet_link" {
  source                     = "../../modules/networking/private_DNS_vnet_link"
  private_dns_zone_link_name = "link-spoke-app-blob"
  resource_group_name        = "rg-prod-dns"
  private_dns_zone_name      = module.private_dns_zone.name
  virtual_network_id         = module.virtual_network.resource_id
  registration_enabled       = false
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| private_dns_zone_link_name | Link name | string | — | yes |
| resource_group_name | RG name (where the zone lives) | string | — | yes |
| private_dns_zone_name | Target Private DNS zone name | string | — | yes |
| virtual_network_id | VNet ID to link | string | — | yes |
| registration_enabled | Auto-register VM records | bool | false | no |
| resolution_policy | Resolution policy | string | "Default" | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | VNet link ID |
| name | VNet link name |

## Production notes
- Keep `registration_enabled = false` for `privatelink.*` zones.
- A VNet can link to a zone only once; name links predictably (`link-<vnet>-<zone>`).
