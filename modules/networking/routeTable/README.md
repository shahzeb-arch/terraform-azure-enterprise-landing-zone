# Route Table (UDR)

## What it is
A route table holds User Defined Routes (UDRs) that override Azure's default
system routing, forcing traffic to specific next hops (e.g. a firewall).

## When to use it (production)
- Force all spoke egress (`0.0.0.0/0`) through Azure Firewall / NVA in the hub.
- Route inter-spoke traffic via the hub for inspection.
- Blackhole / restrict specific ranges.

## Resources created
- `azurerm_route_table`
- `azurerm_subnet_route_table_association` (one per subnet ID provided)

## Usage example
```hcl
module "route_table" {
  source              = "../../modules/networking/routeTable"
  name                = "rt-spoke-app"
  resource_group_name = "rg-prod-network"
  location            = "East US"
  subnet_ids          = [module.subnet.id]
  routes = [
    {
      name                   = "to-firewall"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.0.4" # firewall private IP
    }
  ]
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | Route table name | string | — | yes |
| resource_group_name | RG name | string | — | yes |
| location | Azure region | string | — | yes |
| bgp_route_propagation_enabled | Allow BGP route propagation | bool | true | no |
| routes | List of route objects | list(object) | [] | no |
| subnet_ids | Subnets to associate | list(string) | [] | no |
| tags | Tags | map(string) | {} | no |

## Outputs
| Name | Description |
|---|---|
| id | Route table ID |
| name | Route table name |

## Production notes
- For hub-spoke with a firewall, set `next_hop_type = "VirtualAppliance"` and the
  firewall private IP. The dev sample uses `Internet` only for simplicity.
- Disable BGP propagation on spokes when you want to fully control egress.
