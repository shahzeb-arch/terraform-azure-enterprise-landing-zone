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
  for_each             = var.subnets
  source               = "../../../modules/networking/subnet"
  subnet_name          = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

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
