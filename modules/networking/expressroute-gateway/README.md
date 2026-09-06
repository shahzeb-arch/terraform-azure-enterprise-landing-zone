# ExpressRoute Gateway

## What it is
ExpressRoute virtual network gateway for private connectivity to on-premises or carrier networks.

## When to use it (production)
- Deploy in dedicated GatewaySubnet (/27 minimum).
- Use zone-redundant SKU (ErGw1AZ+).

## Resources created
- `azurerm_virtual_network_gateway` (type = ExpressRoute)

## Usage example
```hcl
module "er_gateway" {
  source              = "../../modules/networking/expressroute-gateway"
  name                = "ergw-hub-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
  ip_configuration = {
    name                 = "vnetGatewayConfig"
    public_ip_address_id = module.pip_er.id
    subnet_id            = module.subnet_gateway.id
  }
}
```

## Production notes
- Pair with ExpressRoute circuit and connection resources separately.
- Enable fastpath on supported SKUs for lower latency.
