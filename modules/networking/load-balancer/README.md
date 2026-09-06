# Load Balancer

## What it is
Basic Azure Load Balancer with a frontend IP configuration (public or internal).

## When to use it (production)
- Internal LB for private service endpoints behind a static private IP.
- Pair with backend pools and rules in separate modules or resources.

## Resources created
- `azurerm_lb`

## Usage example
```hcl
module "lb" {
  source              = "../../modules/networking/load-balancer"
  name                = "lb-internal-app"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
  frontend_ip_configuration = {
    name                          = "fe-config"
    subnet_id                     = module.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.5.10"
  }
}
```

## Production notes
- Use Standard SKU for production workloads with HA requirements.
