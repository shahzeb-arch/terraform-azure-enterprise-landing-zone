# Linux Virtual Machine Scale Set (VMSS)

## What it is
A VMSS manages a group of identical, auto-scalable Linux VMs behind a single
configuration — the standard way to run elastic, stateless workloads.

## When to use it (production)
- Horizontally scalable app/web tiers behind a Load Balancer or App Gateway.
- Workloads needing autoscale, rolling upgrades, and self-healing.

## Resources created
- `azurerm_linux_virtual_machine_scale_set`

## Usage example
```hcl
module "linux_vmss" {
  source               = "../../modules/compute/linux_vmss"
  name                 = "vmss-web"
  resource_group_name  = "rg-prod-app"
  location             = "East US"
  sku                  = "Standard_D2s_v5"
  instances            = 3
  admin_username       = "azureuser"
  admin_ssh_public_key = file("~/.ssh/id_ed25519.pub")
  subnet_id            = module.subnet.id
  zones                = ["1", "2", "3"]
  upgrade_mode         = "Rolling"
  network_interface = {
    name = "vmss-nic"
    ip_configuration = {
      name                                   = "ipconfig1"
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.this.id]
    }
  }
}
```

## Inputs (key)
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | VMSS name | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| location | Azure region | string | — | yes |
| sku | Instance size | string | — | yes |
| instances | Instance count | number | — | yes |
| admin_username | Admin user | string | — | yes |
| admin_ssh_public_key | SSH key (sensitive) | string | — | yes |
| subnet_id | Subnet for instances | string | — | yes |
| network_interface | NIC + ip_configuration object | object | — | yes |
| upgrade_mode | Manual/Automatic/Rolling | string | "Manual" | no |
| zones | Availability zones | list(string) | [] | no |
| encryption_at_host_enabled / secure_boot_enabled / vtpm_enabled | Security | bool | true | no |
| os_disk / source_image_reference | Disk + image | object | Premium / Ubuntu 22.04 | no |
| identity / boot_diagnostics | Identity / diag | object | null | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | VMSS ID |
| name | VMSS name |
| principal_id | System-assigned identity principal ID |
| unique_id | VMSS unique ID |

## Production notes
- Use `upgrade_mode = "Rolling"` + a health probe for zero-downtime updates.
- Spread across `zones` for resiliency; pair with autoscale rules.
- Attach to a Load Balancer / App Gateway backend pool via `ip_configuration`.
