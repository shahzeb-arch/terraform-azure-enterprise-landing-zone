# Application Gateway

## What it is
Layer-7 load balancer with optional WAF_v2 for HTTP/S traffic termination and routing.

## When to use it (production)
- Use WAF_v2 SKU with Prevention mode.
- Deploy in dedicated subnet (/24 minimum).

## Resources created
- `azurerm_application_gateway`

## Usage example
```hcl
module "appgw" {
  source              = "../../modules/networking/application-gateway"
  name                = "agw-corp-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-network"
  gateway_ip_configuration = {
    name      = "appGatewayIpConfig"
    subnet_id = module.subnet_appgw.id
  }
  frontend_ip_configurations = [{
    name                 = "public"
    public_ip_address_id = module.pip_appgw.id
  }]
}
```

## Production notes
- Store TLS certificates in Key Vault and reference via user-assigned identity.
- Enable diagnostic settings and WAF logs to Log Analytics.
