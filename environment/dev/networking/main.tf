# Dev / networking layer.
# Creates the foundation networking stack: resource groups, virtual networks,
# subnets, NSGs, route tables and NAT gateways. Compute (NIC/VM/VMSS) lives in
# the sibling `environment/dev/compute` layer so the two have independent state
# and lifecycle.
module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/foundation/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "virtual_network" {
  for_each             = var.virtual_networks
  source               = "../../../modules/networking/virtualNetwork"
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
  location             = each.value.location
  address_space        = each.value.address_space
  tags                 = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "subnet" {
  for_each                          = var.subnets
  source                            = "../../../modules/networking/subnet"
  subnet_name                       = each.value.subnet_name
  resource_group_name               = each.value.resource_group_name
  virtual_network_name              = each.value.virtual_network_name
  address_prefixes                  = each.value.address_prefixes
  private_endpoint_network_policies = each.value.private_endpoint_network_policies

  depends_on = [module.virtual_network]
}

module "network_security_group" {
  for_each = var.network_security_groups
  source   = "../../../modules/networking/networkSecurityGroup"

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  security_rules      = each.value.security_rules
  subnet_ids          = [for subnet_key in each.value.subnet_keys : module.subnet[subnet_key].id]
  tags                = merge(var.common_tags, each.value.tags)

  depends_on = [module.subnet]
}

module "route_table" {
  for_each = var.route_tables
  source   = "../../../modules/networking/routeTable"

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
  routes                        = each.value.routes
  subnet_ids                    = [for subnet_key in each.value.subnet_keys : module.subnet[subnet_key].id]
  tags                          = merge(var.common_tags, each.value.tags)

  depends_on = [module.subnet]
}

module "nat_gateway" {
  for_each = var.nat_gateway
  source   = "../../../modules/networking/nat_gateway"

  nat_gateway_name        = each.value.nat_gateway_name
  location                = each.value.location
  resource_group_name     = each.value.resource_group_name
  sku_name                = each.value.sku_name
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  zones                   = each.value.zones
  tags                    = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "public_ip" {
  for_each = var.public_ips
  source   = "../../../modules/networking/publicIP"

  public_ip_name      = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  sku_tier            = each.value.sku_tier
  zones               = each.value.zones
  tags                = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

locals {
  nat_subnet_associations = flatten([
    for nat_key, cfg in var.nat_gateway_associations : [
      for idx, subnet_key in cfg.subnet_keys : {
        key             = "${nat_key}-${subnet_key}"
        nat_gateway_key = nat_key
        subnet_key      = subnet_key
        public_ip_keys  = idx == 0 ? cfg.public_ip_keys : []
      }
    ]
  ])
}

module "nat_association" {
  for_each = { for assoc in local.nat_subnet_associations : assoc.key => assoc }
  source   = "../../../modules/networking/nat_association"

  subnet_id      = module.subnet[each.value.subnet_key].id
  nat_gateway_id = module.nat_gateway[each.value.nat_gateway_key].id
  public_ip_address_ids = [
    for pip_key in each.value.public_ip_keys : module.public_ip[pip_key].id
  ]

  depends_on = [module.subnet, module.nat_gateway, module.public_ip]
}

module "private_dns_zone" {
  for_each = var.private_dns_zones
  source   = "../../../modules/networking/private_DNS_Zone"

  private_dns_zone_name = each.value.private_dns_zone_name
  resource_group_name   = each.value.resource_group_name
  soa_record            = each.value.soa_record
  tags                  = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "private_dns_vnet_link" {
  for_each = var.private_dns_vnet_links
  source   = "../../../modules/networking/private_DNS_vnet_link"

  private_dns_zone_link_name = each.value.private_dns_zone_link_name
  resource_group_name        = each.value.resource_group_name
  private_dns_zone_name      = module.private_dns_zone[each.value.private_dns_zone_key].name
  virtual_network_id         = module.virtual_network[each.value.virtual_network_key].resource_id
  registration_enabled       = each.value.registration_enabled
  resolution_policy          = each.value.resolution_policy
  tags                       = merge(var.common_tags, each.value.tags)

  depends_on = [module.private_dns_zone, module.virtual_network]
}
