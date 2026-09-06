# Key Vault

## What it is
Azure Key Vault for secrets, keys, and certificates with RBAC and network hardening.

## When to use it (production)
- Centralize secrets with RBAC (not access policies).
- Disable public access; use Private Endpoints.
- Enable purge protection and 90-day soft delete.

## Resources created
- `azurerm_key_vault`

## Usage example
```hcl
module "key_vault" {
  source              = "../../modules/security/key-vault"
  name                = "kv-prod-secrets"
  location            = "eastus"
  resource_group_name = "rg-prod-security"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}
```

## Production notes
- Assign RBAC roles (e.g. Key Vault Secrets User) after creation.
- Pair with `private-endpoint` module on `snet-pe` subnets.
