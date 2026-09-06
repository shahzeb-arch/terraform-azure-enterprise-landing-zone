# Resource Group

## What it is
An Azure Resource Group — a logical container that holds related Azure resources
(VNets, VMs, storage, etc.). Every Azure resource must live inside one.

## When to use it (production)
- As the first thing created in any layer (network RG, compute RG, shared RG).
- One RG per workload + environment + lifecycle (e.g. `rg-prod-network`, `rg-prod-app`).
- Keeps RBAC, cost tracking, and deletion boundaries clean.

## Resources created
- `azurerm_resource_group`

## Usage example
```hcl
module "resource_group" {
  source                  = "../../modules/foundation/resourceGroup"
  resource_group_name     = "rg-prod-network"
  resource_group_location = "East US"
  tags = {
    Environment = "prod"
    CostCenter  = "platform"
  }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| resource_group_name | Name of the resource group | string | — | yes |
| resource_group_location | Azure region | string | — | yes |
| tags | Tags to apply | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | Resource group ID |
| name | Resource group name |
| location | Resource group location |

## Production notes
- Apply a consistent naming convention: `rg-<env>-<purpose>`.
- Consider adding a resource lock (CanNotDelete) on critical RGs.
- Tag every RG for cost allocation and ownership.
