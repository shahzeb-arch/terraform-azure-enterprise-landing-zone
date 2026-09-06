# Policy Assignment

## What it is
Assigns an Azure Policy or initiative to a subscription or resource group.

## When to use it (production)
- Enforce tagging, encryption, and location restrictions org-wide.
- Use subscription scope for landing zones; RG scope for workload exceptions.

## Resources created
- `azurerm_subscription_policy_assignment` or `azurerm_resource_group_policy_assignment`

## Usage example
```hcl
module "policy_assignment" {
  source               = "../../modules/governence/policy-assignment"
  name                 = "assign-require-tags"
  display_name         = "Require standard tags"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/..."
  scope_type           = "subscription"
  scope_id             = data.azurerm_subscription.current.id
}
```

## Production notes
- Set `enforce = false` initially to audit before full enforcement.
