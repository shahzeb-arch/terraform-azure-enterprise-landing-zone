# Terraform State Backend (Bootstrap)

## What it is
Bootstrap module creating resource group, storage account, and private container for remote Terraform state.

## When to use it (production)
- Run once per tenant/environment before any other layer.
- Enable Azure AD auth on backend (`use_azuread_auth = true` in backend config).

## Resources created
- `azurerm_resource_group`
- `azurerm_storage_account`
- `azurerm_storage_container`

## Usage example
```hcl
module "state_backend" {
  source               = "../../modules/foundation/state-backend"
  location             = "eastus"
  storage_account_name = "stterraformstateprod"
}
```

## Production notes
- Apply from local state first, then migrate layers to remote backend.
- Grant Storage Blob Data Contributor to CI/CD service principals.
