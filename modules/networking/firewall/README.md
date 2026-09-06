# Azure Firewall

## What it is
Hub VNet Azure Firewall for centralized egress/ingress filtering via Firewall Policy.

## When to use it (production)
- Deploy in dedicated `AzureFirewallSubnet` (/26 minimum).
- Attach a `firewall-policy` module for rule collections.

## Resources created
- `azurerm_firewall`

## Usage example
```hcl
module "firewall" {
  source              = "../../modules/networking/firewall"
  name                = "afw-hub-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
  firewall_policy_id  = module.firewall_policy.id
  ip_configuration = {
    name                 = "configuration"
    subnet_id            = module.subnet_firewall.id
    public_ip_address_id = module.pip_firewall.id
  }
}
```

## Production notes
- Route spoke default traffic (0.0.0.0/0) to the firewall private IP.
