# NAT Gateway Associations

## What it is
Wires a NAT Gateway to the resources it serves: associates it with a subnet and
attaches the public IP(s) used for outbound SNAT.

## When to use it (production)
- Always paired with the `nat_gateway` and `publicIP` modules to make outbound
  connectivity actually work for a subnet.

## Resources created
- `azurerm_subnet_nat_gateway_association`
- `azurerm_nat_gateway_public_ip_association` (one per public IP)

## Usage example
```hcl
module "nat_association" {
  source                = "../../modules/networking/nat_association"
  subnet_id             = module.subnet.id
  nat_gateway_id        = module.nat_gateway.id
  public_ip_address_ids = [module.public_ip.id]
}
```

## Inputs
| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| subnet_id | Subnet to associate | string | — | yes |
| nat_gateway_id | NAT Gateway ID | string | — | yes |
| public_ip_address_ids | Public IPs for SNAT | list(string) | [] | no |

## Outputs
| Name | Description |
|---|---|
| subnet_association_id | Subnet association ID |
| public_ip_association_ids | Map of public IP association IDs |

## Production notes
- A subnet can be associated with only one NAT Gateway.
- Add multiple public IPs (or a public IP prefix) to increase SNAT ports.
