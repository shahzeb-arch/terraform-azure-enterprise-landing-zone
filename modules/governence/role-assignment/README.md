# Role Assignment

## What it is
Azure RBAC role assignment granting permissions to a principal at a scope.

## When to use it (production)
- Grant managed identities least-privilege access to Key Vault, AKS, etc.
- Prefer built-in roles over custom unless org requires fine-grained control.

## Resources created
- `azurerm_role_assignment`

## Usage example
```hcl
module "role_assignment" {
  source               = "../../modules/governence/role-assignment"
  scope                = module.key_vault.id
  principal_id         = module.identity.principal_id
  role_definition_name = "Key Vault Secrets User"
}
```

## Production notes
- Use `skip_service_principal_aad_check = true` only for brand-new SPs in the same apply.
