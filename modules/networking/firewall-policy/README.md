# Firewall Policy

## What it is
Centralized Azure Firewall Policy with optional rule collection groups.

## When to use it (production)
- Manage application, network, and NAT rules separately from the firewall resource.
- Share one policy across multiple firewalls in a hub.

## Resources created
- `azurerm_firewall_policy`
- `azurerm_firewall_policy_rule_collection_group` (optional)

## Usage example
```hcl
module "firewall_policy" {
  source              = "../../modules/networking/firewall-policy"
  name                = "afwp-hub-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
}
```

## Production notes
- Enable threat intelligence in Deny mode for production egress filtering.
