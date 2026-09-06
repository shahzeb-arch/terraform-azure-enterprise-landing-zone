# Policy Definition

## What it is
Custom Azure Policy definition for governance and compliance enforcement.

## When to use it (production)
- Encode org standards (tags, regions, SKUs) as reusable policies.
- Assign via the `policy-assignment` module at subscription or RG scope.

## Resources created
- `azurerm_policy_definition`

## Usage example
```hcl
module "policy" {
  source       = "../../modules/governence/policy"
  name         = "require-env-tag"
  display_name = "Require Environment tag"
  policy_rule  = file("policies/require-env-tag.json")
}
```

## Production notes
- Prefer built-in policies where possible; use custom for org-specific rules.
