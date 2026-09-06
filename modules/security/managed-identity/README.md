# Managed Identity

## What it is
User-assigned managed identity for secure, credential-free Azure resource authentication.

## When to use it (production)
- Assign to AKS, VMs, or automation without storing secrets.
- One identity shared across multiple resources in a workload.

## Resources created
- `azurerm_user_assigned_identity`

## Usage example
```hcl
module "identity" {
  source              = "../../modules/security/managed-identity"
  name                = "id-prod-aks"
  location            = "eastus"
  resource_group_name = "rg-prod-security"
}
```

## Production notes
- Grant least-privilege RBAC via the `role-assignment` module.
