# Private Endpoint DNS Zone Group

## What it is
Associates private DNS zones with an existing private endpoint for automatic DNS resolution.

## When to use it (production)
- Attach zone groups after private endpoint creation for PaaS services.
- Use hub private DNS zones linked to spoke VNets.

## Resources created
- `azurerm_private_endpoint_dns_zone_group`

## Usage example
```hcl
module "pe_dns" {
  source               = "../../modules/security/private-dns-zone-group"
  private_endpoint_id  = module.private_endpoint.id
  private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
}
```

## Production notes
- Prefer central private DNS in hub-and-spoke topology.
- Zone names must match the PaaS service FQDN pattern.
