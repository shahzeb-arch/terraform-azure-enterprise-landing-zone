# Azure Front Door

## What it is
Global CDN and load balancing with optional WAF for public-facing applications.

## When to use it (production)
- Use Premium SKU for managed WAF rules.
- Terminate TLS at Front Door with modern cipher suites.

## Resources created
- `azurerm_cdn_frontdoor_profile`
- `azurerm_cdn_frontdoor_endpoint`
- `azurerm_cdn_frontdoor_firewall_policy` (optional)

## Usage example
```hcl
module "frontdoor" {
  source              = "../../modules/networking/frontdoor"
  name                = "afd-corp-prod"
  resource_group_name = "rg-prod-network"
  endpoints = {
    primary = { name = "afd-endpoint-prod" }
  }
  waf_policy = {
    name = "wafafdprod"
  }
}
```

## Production notes
- Add origin groups, routes, and custom domains in follow-on modules or tfvars.
- Enable diagnostic settings for access and WAF logs.
