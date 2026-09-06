# Automation Account

## What it is
Azure Automation account for runbooks, update management, and configuration drift remediation.

## When to use it (production)
- Use SystemAssigned identity for Azure resource automation.
- Store credentials in Key Vault, not in runbooks.

## Resources created
- `azurerm_automation_account`

## Usage example
```hcl
module "automation" {
  source              = "../../modules/management/automation-account"
  name                = "aa-platform-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-management"
}
```

## Production notes
- Enable private link for automation account in regulated environments.
- Assign least-privilege RBAC to the managed identity.
