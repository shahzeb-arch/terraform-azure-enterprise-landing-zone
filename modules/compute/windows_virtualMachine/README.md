# Windows Virtual Machine

## What it is
A single Windows Server VM with secure-by-default settings (encryption at host,
secure boot, vTPM, VM agent) and password-based admin auth.

## When to use it (production)
- Windows-specific workloads (AD, .NET apps, file servers, legacy software).
- For scalable, stateless Windows workloads consider a Windows VMSS instead.

## Resources created
- `azurerm_windows_virtual_machine`

## Usage example
```hcl
module "windows_vm" {
  source                = "../../modules/compute/windows_virtualMachine"
  name                  = "vm-win-01"
  resource_group_name   = "rg-prod-app"
  location              = "East US"
  size                  = "Standard_D2s_v5"
  admin_username        = "azureadmin"
  admin_password        = var.win_admin_password # via TF_VAR / Key Vault
  network_interface_ids = [module.network_interface.id]
  zone                  = "1"
}
```

## Inputs (key)
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | VM name | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| location | Azure region | string | — | yes |
| size | VM size | string | — | yes |
| admin_username | Admin user | string | — | yes |
| admin_password | Admin password (sensitive) | string | — | yes |
| network_interface_ids | NIC IDs | list(string) | — | yes |
| encryption_at_host_enabled | Encrypt temp/cache disks | bool | true | no |
| patch_mode | Patch mode | string | "AutomaticByOS" | no |
| secure_boot_enabled / vtpm_enabled | Trusted launch | bool | true | no |
| zone | Availability zone | string | null | no |
| os_disk | OS disk config | object | Premium_LRS | no |
| source_image_reference | Image | object | WinServer 2022 | no |
| identity | Managed identity | object | null | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | VM ID |
| name | VM name |
| private_ip_address | Primary private IP |
| principal_id | System-assigned identity principal ID |

## Production notes
- NEVER hardcode `admin_password` — pass via `TF_VAR_...` env var or Key Vault.
- Pin the image `version` for reproducibility.
- Use a zone (or availability set) + boot diagnostics for resiliency.
