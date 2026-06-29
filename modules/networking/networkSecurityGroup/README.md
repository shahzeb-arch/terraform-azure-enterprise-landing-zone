# Network Security Group (NSG)

## What it is
An NSG is a stateful firewall of allow/deny rules controlling inbound and outbound
traffic to subnets and NICs, based on IPs, ports, and protocols.

## When to use it (production)
- Attach to every workload subnet to enforce least-privilege traffic.
- Layer with Azure Firewall: NSG = micro-segmentation, Firewall = central egress.

## Resources created
- `azurerm_network_security_group`
- `azurerm_subnet_network_security_group_association` (one per subnet ID provided)

## Usage example
```hcl
module "network_security_group" {
  source              = "../../modules/networking/networkSecurityGroup"
  name                = "nsg-app"
  resource_group_name = "rg-prod-network"
  location            = "East US"
  subnet_ids          = [module.subnet.id]
  security_rules = [
    {
      name                       = "allow_https"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
    }
  ]
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | NSG name | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| location | Azure region | string | — | yes |
| security_rules | List of rule objects | list(object) | [] | no |
| subnet_ids | Subnets to associate | list(string) | [] | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | NSG ID |
| name | NSG name |

## Production notes
- Never allow management ports (22/3389) from `0.0.0.0/0` — use Bastion or a
  corp CIDR. (The dev sample restricts SSH to `10.0.0.0/8`.)
- Lower priority number = higher precedence; leave gaps (100, 200, 300) for inserts.
- Send NSG flow logs to Log Analytics for auditing.
