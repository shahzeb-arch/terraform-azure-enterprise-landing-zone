# VPN Gateway

## What it is
Site-to-site or point-to-site VPN gateway deployed in `GatewaySubnet`.

## When to use it (production)
- Use zone-redundant SKU (VpnGw1AZ+) and RouteBased VPN.
- Reserve /27 or larger for GatewaySubnet.

## Resources created
- `azurerm_virtual_network_gateway` (type = Vpn)

## Usage example
```hcl
module "vpn_gateway" {
  source              = "../../modules/networking/vpn-gateway"
  name                = "vgw-hub-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
  ip_configuration = {
    name                 = "vnetGatewayConfig"
    public_ip_address_id = module.pip_vpn.id
    subnet_id            = module.subnet_gateway.id
  }
}
```

## Production notes
- Enable BGP when using multiple tunnels or ExpressRoute coexistence.
- Monitor gateway metrics via Azure Monitor.
