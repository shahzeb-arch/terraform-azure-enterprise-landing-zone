# Linux Virtual Machine

## What it is
A single Linux VM with SSH-key auth and secure-by-default settings
(encryption at host, secure boot, vTPM, password auth disabled).

## When to use it (production)
- Pets / fixed-role servers (jump hosts, legacy apps, tooling).
- For scalable, stateless workloads prefer VMSS instead.

## Resources created
- `azurerm_linux_virtual_machine`

## Usage example
```hcl
module "linux_vm" {
  source                = "../../modules/compute/linux_virtualMachine"
  name                  = "vm-tools-01"
  resource_group_name   = "rg-prod-app"
  location              = "East US"
  size                  = "Standard_D2s_v5"
  admin_username        = "azureuser"
  admin_ssh_public_key  = file("~/.ssh/id_ed25519.pub")
  network_interface_ids = [module.network_interface.id]
  zone                  = "1"
  identity              = { type = "SystemAssigned" }
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
| admin_ssh_public_key | SSH public key (sensitive) | string | — | yes |
| network_interface_ids | NIC IDs | list(string) | — | yes |
| encryption_at_host_enabled | Encrypt temp/cache disks | bool | true | no |
| secure_boot_enabled / vtpm_enabled | Trusted launch | bool | true | no |
| zone | Availability zone | string | null | no |
| os_disk | OS disk config | object | Premium_LRS | no |
| source_image_reference | Image | object | Ubuntu 22.04 | no |
| identity | Managed identity | object | null | no |
| boot_diagnostics | Boot diag config | object | null | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | VM ID |
| name | VM name |
| private_ip_address | Primary private IP |
| principal_id | System-assigned identity principal ID |

## Production notes
- Password auth is hard-disabled — SSH keys only.
- Pin `source_image_reference.version` for reproducible builds (avoid `latest`).
- Use a zone (or availability set) for resiliency; enable boot diagnostics.
- `encryption_at_host` requires the feature to be registered on the subscription.
