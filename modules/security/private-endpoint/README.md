# Private Endpoint

## What it is
Private Link endpoint that exposes a PaaS resource on a private IP inside your VNet.

## When to use it (production)
- Access Key Vault, Storage, SQL, etc. without public internet.
- Deploy on dedicated `snet-pe` subnets with PE network policies disabled.

## Resources created
- `azurerm_private_endpoint`

## Usage example
```hcl
module "kv_pe" {
  source              = "../../modules/security/private-endpoint"
  name                = "pe-kv-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
  subnet_id           = module.subnet.id
  private_service_connection = {
    name                           = "kv-connection"
    private_connection_resource_id = module.key_vault.id
    subresource_names              = ["vault"]
  }
}
```

## Production notes
- Always attach a `private_dns_zone_group` for name resolution.
