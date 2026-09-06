# Custom Role Definition

## What it is
Defines a custom Azure RBAC role with explicit action permissions.

## When to use it (production)
- Create least-privilege roles for platform teams and automation identities.
- Prefer built-in roles when they meet requirements.

## Resources created
- `azurerm_role_definition`

## Usage example
```hcl
module "role" {
  source = "../../modules/governence/role-definition"
  name   = "Platform Network Operator"
  scope  = data.azurerm_subscription.current.id
  permissions = {
    actions = [
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/write"
    ]
  }
}
```

## Production notes
- Limit assignable_scopes to required subscriptions or management groups.
- Document role purpose for audit reviews.
