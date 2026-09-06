# Bastion Host

## What it is
Azure Bastion for secure RDP/SSH to VMs over TLS without public VM IPs.

## When to use it (production)
- Deploy in dedicated `AzureBastionSubnet` (/26 minimum).
- Disable copy/paste and file copy unless required.

## Resources created
- `azurerm_bastion_host`

## Usage example
```hcl
module "bastion" {
  source              = "../../modules/networking/bastion"
  name                = "bas-hub-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
  ip_configuration = {
    name                 = "configuration"
    subnet_id            = module.subnet_bastion.id
    public_ip_address_id = module.pip_bastion.id
  }
}
```

## Production notes
- Use Standard SKU only when advanced features (tunneling, shareable links) are needed.
