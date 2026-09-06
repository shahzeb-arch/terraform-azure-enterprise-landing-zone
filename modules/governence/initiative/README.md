# Policy Initiative (Set Definition)

## What it is
Custom policy initiative grouping multiple policy definitions for assignment at MG or subscription scope.

## When to use it (production)
- Wrap Microsoft CAF initiatives or compose org-specific bundles.
- Assign via the policy-assignment module.

## Resources created
- `azurerm_policy_set_definition`

## Usage example
```hcl
module "initiative" {
  source       = "../../modules/governence/initiative"
  name         = "corp-security-baseline"
  display_name = "Corp Security Baseline"
  policy_definition_references = [{
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/..."
  }]
}
```

## Production notes
- Prefer built-in CAF initiatives where possible; customize parameters only.
- Version policy references for reproducible deployments.
