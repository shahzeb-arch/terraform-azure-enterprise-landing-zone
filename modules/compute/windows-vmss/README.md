# Windows Virtual Machine Scale Set

## What it is
Zone-redundant Windows VM scale set with secure boot, vTPM, and encryption-at-host defaults.

## When to use it (production)
- Use Rolling upgrade mode with health probes.
- Store credentials in Key Vault; prefer Azure AD login where possible.

## Resources created
- `azurerm_windows_virtual_machine_scale_set`

## Usage example
```hcl
module "win_vmss" {
  source              = "../../modules/compute/windows-vmss"
  name                = "vmss-app-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-compute"
  sku                 = "Standard_D2s_v5"
  admin_username      = "azureadmin"
  admin_password      = var.admin_password
  subnet_id           = module.subnet_app.id
  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
  }
}
```

## Production notes
- Attach to load balancer backend pools for HA.
- Enable boot diagnostics to a dedicated storage account.
