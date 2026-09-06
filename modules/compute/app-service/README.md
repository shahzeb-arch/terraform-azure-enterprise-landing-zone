# App Service (Linux Web App)

## What it is
Azure Linux Web App for hosting web applications on App Service.

## When to use it (production)
- PaaS web workloads with managed scaling
- VNet integration for private backend access

## Resources created
- azurerm_linux_web_app

## Usage example
```hcl
module "app_service" {
  source              = "../../../modules/compute/app-service"
  name                = "app-platform-dev"
  location            = "eastus"
  resource_group_name = "rg-dev-compute"
  service_plan_id     = module.service_plan.id
}
```

## Production notes
- Enable `vnet_route_all_enabled` when using private endpoints for backends.
- Use user-assigned managed identity for Key Vault references.
