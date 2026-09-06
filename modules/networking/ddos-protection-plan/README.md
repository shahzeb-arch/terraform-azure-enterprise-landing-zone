# DDoS Protection Plan

## What it is
Azure DDoS Network Protection plan for VNet-level DDoS mitigation.

## When to use it (production)
- Associate with hub and critical spoke VNets.
- Enable on all internet-facing workloads.

## Resources created
- `azurerm_network_ddos_protection_plan`

## Usage example
```hcl
module "ddos_plan" {
  source              = "../../modules/networking/ddos-protection-plan"
  name                = "ddos-hub-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
}
```

## Production notes
- DDoS plan is billed per protected VNet; centralize on hub where possible.
- Enable diagnostic settings for attack analytics.
