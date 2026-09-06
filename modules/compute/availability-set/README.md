# Availability Set

## What it is
Fault and update domain grouping for classic VM availability (prefer VMSS or zone redundancy in new designs).

## When to use it (production)
- Use for legacy multi-VM deployments without VMSS.
- Pair with load balancer health probes.

## Resources created
- `azurerm_availability_set`

## Usage example
```hcl
module "avset" {
  source              = "../../modules/compute/availability-set"
  name                = "avset-app-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-compute"
}
```

## Production notes
- Prefer zone-redundant VMSS over availability sets for new workloads.
- Align fault domain count with region capabilities.
