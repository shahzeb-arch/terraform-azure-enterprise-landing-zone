# Storage Account

## What it is
Secure Azure Storage account with HTTPS-only, TLS 1.2, and no public blob access by default.

## When to use it (production)
- Disable public blob access and shared keys.
- Use private endpoints and network rules.

## Resources created
- `azurerm_storage_account`

## Usage example
```hcl
module "storage" {
  source              = "../../modules/data/storage-account"
  name                = "stcorpprod001"
  location            = "eastus"
  resource_group_name = "rg-prod-data"
}
```

## Production notes
- Enable soft delete and versioning on blob containers.
- Use customer-managed keys for sensitive data.
