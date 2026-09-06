# Naming

## What it is
Locals-based naming helper producing consistent org-env-region-workload names.

## When to use it (production)
- Enforce naming standards across all ELZ layers.
- Generate RG, VNet, KV, and monitoring names from one module call.

## Resources created
- None (locals-only module)

## Usage example
```hcl
module "naming" {
  source   = "../../modules/shared/naming"
  org      = "contoso"
  env      = "prod"
  region   = "eus"
  workload = "network"
}
# module.naming.resource_group => "rg-contoso-prod-eus-network"
```

## Production notes
- Key Vault names are truncated to 24 alphanumeric characters.
