# Dev / landing-zone-corp layer.
# Corporate spoke virtual network peered to the platform hub.
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
  resource_group_name  = module.resource_group[each.value.resource_group_key].name
  location             = each.value.location
  address_space        = each.value.address_space
  tags                 = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "subnet" {
  for_each                          = var.subnets
  source                            = "../../../modules/networking/subnet"
  subnet_name                       = each.value.subnet_name
  resource_group_name               = module.resource_group[each.value.resource_group_key].name
  virtual_network_name              = each.value.virtual_network_name
  address_prefixes                  = each.value.address_prefixes
  private_endpoint_network_policies = each.value.private_endpoint_network_policies

  depends_on = [module.virtual_network]
}

module "hub_to_spoke_peering" {
  for_each = var.vnet_peerings
  source   = "../../../modules/networking/virtual_network-peering"

  name                      = each.value.hub_peering_name
  resource_group_name       = data.azurerm_resource_group.hub.name
  virtual_network_name      = data.azurerm_virtual_network.hub.name
  remote_virtual_network_id = module.virtual_network[each.value.spoke_vnet_key].id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
  allow_gateway_transit     = each.value.allow_gateway_transit
  use_remote_gateways       = each.value.use_remote_gateways

  depends_on = [module.virtual_network]
}

module "spoke_to_hub_peering" {
  for_each = var.vnet_peerings
  source   = "../../../modules/networking/virtual_network-peering"

  name                      = each.value.spoke_peering_name
  resource_group_name       = module.resource_group[each.value.resource_group_key].name
  virtual_network_name      = module.virtual_network[each.value.spoke_vnet_key].name
  remote_virtual_network_id = data.azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
  allow_gateway_transit     = each.value.allow_gateway_transit
  use_remote_gateways       = each.value.use_remote_gateways

  depends_on = [module.virtual_network]
}
