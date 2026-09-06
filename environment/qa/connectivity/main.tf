# Dev / connectivity layer.
# Hub firewall, bastion, and VNet peering wired to existing networking (rg-qa-network / vnet-1).
module "firewall_policy" {
  for_each = var.firewall_policies
  source   = "../../../modules/networking/firewall-policy"

  name                     = each.value.name
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.network.name
  sku                      = each.value.sku
  dns_proxy_enabled        = each.value.dns_proxy_enabled
  threat_intelligence_mode = each.value.threat_intelligence_mode
  rule_collection_group    = each.value.rule_collection_group
  tags                     = merge(var.common_tags, each.value.tags)
}

module "public_ip" {
  for_each = var.public_ips
  source   = "../../../modules/networking/publicIP"

  public_ip_name      = each.value.public_ip_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.network.name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  zones               = each.value.zones
  tags                = merge(var.common_tags, each.value.tags)
}

module "firewall" {
  for_each = var.firewalls
  source   = "../../../modules/networking/firewall"

  name                = each.value.name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.network.name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  firewall_policy_id  = module.firewall_policy[each.value.firewall_policy_key].id
  zones               = each.value.zones
  ip_configuration = {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.firewall.id
    public_ip_address_id = module.public_ip[each.value.public_ip_key].id
  }
  tags = merge(var.common_tags, each.value.tags)

  depends_on = [module.firewall_policy, module.public_ip]
}

module "bastion" {
  for_each = var.bastion_hosts
  source   = "../../../modules/networking/bastion"

  name                = each.value.name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.network.name
  sku                 = each.value.sku
  ip_configuration = {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.bastion.id
    public_ip_address_id = module.public_ip[each.value.public_ip_key].id
  }
  tags = merge(var.common_tags, each.value.tags)

  depends_on = [module.public_ip]
}

module "vnet_peering" {
  for_each = var.vnet_peerings
  source   = "../../../modules/networking/virtual_network-peering"

  name                      = each.value.name
  resource_group_name       = data.azurerm_resource_group.network.name
  virtual_network_name      = data.azurerm_virtual_network.hub.name
  remote_virtual_network_id = each.value.remote_virtual_network_id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
  allow_gateway_transit     = each.value.allow_gateway_transit
  use_remote_gateways       = each.value.use_remote_gateways
}
