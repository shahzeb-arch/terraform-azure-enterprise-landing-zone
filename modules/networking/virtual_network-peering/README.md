# Virtual Network Peering

## What it is
Peering connection between two VNets for private routing without a gateway.

## When to use it (production)
- Hub-spoke topology: peer spokes to hub with forwarded traffic enabled.
- Create reciprocal peering on both VNets.

## Resources created
- `azurerm_virtual_network_peering`

## Usage example
```hcl
module "peering" {
  source                    = "../../modules/networking/virtual_network-peering"
  name                      = "hub-to-spoke1"
  resource_group_name       = "rg-prod-network"
  virtual_network_name      = "vnet-hub"
  remote_virtual_network_id = module.spoke_vnet.id
  allow_forwarded_traffic   = true
}
```

## Production notes
- Only one side should set `use_remote_gateways = true`.
