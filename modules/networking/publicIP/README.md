# Public IP

## What it is
A Public IP Address resource that can be attached to internet-facing resources
(Load Balancer, Application Gateway, Azure Firewall, NAT Gateway, Bastion, VMs).

## When to use it (production)
- Frontend IP for Standard Load Balancer / Application Gateway.
- Outbound IP for a NAT Gateway or Azure Firewall.
- Required by Azure Bastion and VPN/ExpressRoute gateways.

## Resources created
- `azurerm_public_ip`

## Usage example
```hcl
module "public_ip" {
  source              = "../../modules/networking/publicIP"
  public_ip_name      = "pip-natgw-prod"
  resource_group_name = "rg-prod-network"
  location            = "East US"
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"] # zone-redundant
  tags                = { Environment = "prod" }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| public_ip_name | Public IP name | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| location | Azure region | string | — | yes |
| allocation_method | Static or Dynamic | string | "Static" | no |
| sku | Basic/Standard/StandardV2 | string | "Standard" | no |
| sku_tier | Regional or Global | string | "Regional" | no |
| zones | Availability zones | list(string) | null | no |
| ddos_protection_mode | DDoS mode | string | null | no |
| ddos_protection_plan_id | DDoS plan ID | string | null | no |
| idle_timeout_in_minutes | TCP idle timeout (4-30) | number | 4 | no |
| domain_name_label | DNS label for FQDN | string | null | no |
| ip_version | IPv4 or IPv6 | string | "IPv4" | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | Public IP ID |
| name | Public IP name |
| ip_address | Allocated IP (once assigned) |
| fqdn | FQDN if domain label set |

## Production notes
- Use `Standard` SKU + `Static` allocation (Basic SKU is retired).
- For HA, deploy zone-redundant Public IPs (`zones = ["1","2","3"]`).
- Minimise public IPs — prefer Private Endpoints / NAT Gateway for egress.
