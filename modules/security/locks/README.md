# Locks

## What it is
Azure management lock preventing accidental deletion or modification of critical resources.

## When to use it (production)
- Apply CanNotDelete locks on production RGs, Key Vaults, and networking.
- Use ReadOnly for audit-only subscriptions.

## Resources created
- `azurerm_management_lock`

## Usage example
```hcl
module "lock" {
  source     = "../../modules/security/locks"
  name       = "lock-rg-prod"
  scope      = azurerm_resource_group.prod.id
  lock_level = "CanNotDelete"
}
```

## Production notes
- Locks must be removed before Terraform destroy of the scoped resource.
