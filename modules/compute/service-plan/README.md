# Service Plan

## What it is
Azure App Service plan — compute host for Web Apps and Function Apps.

## When to use it (production)
- Shared compute pool for multiple apps
- Scale-out and SKU tier control (P1v3+ for production)

## Resources created
- azurerm_service_plan

## Usage example
```hcl
module "service_plan" {
  source              = "../../../modules/compute/service-plan"
  name                = "asp-platform-dev"
  location            = "eastus"
  resource_group_name = "rg-dev-compute"
  os_type             = "Linux"
  sku_name            = "P1v3"
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | App Service plan name | string | — | yes |
| location | Azure region | string | — | yes |
| resource_group_name | Resource group | string | — | yes |
| os_type | Linux or Windows | string | Linux | no |
| sku_name | Plan SKU | string | P1v3 | no |

## Outputs
| Name | Description |
|---|---|
| id | Service plan ID |
| name | Service plan name |

## Production notes
- Use Premium v3 (P1v3+) for production; Y1/EP1 for consumption/elastic workloads.
