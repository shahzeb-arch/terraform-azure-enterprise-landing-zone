# Dev / connectivity layer.
# Hub firewall, bastion, and VNet peering wired to existing networking (rg-dev-network / vnet-1).
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

module "ddos_protection_plan" {
  for_each = var.ddos_protection_plans
  source   = "../../../modules/networking/ddos-protection-plan"

  name                = each.value.name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.network.name
  tags                = merge(var.common_tags, each.value.tags)
}

module "vpn_gateway" {
  for_each = var.vpn_gateways
  source   = "../../../modules/networking/vpn-gateway"

  name                = each.value.name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.network.name
  sku                 = each.value.sku
  vpn_type            = each.value.vpn_type
  active_active       = each.value.active_active
  enable_bgp          = each.value.enable_bgp
  ip_configuration = {
    name                 = each.value.ip_configuration.name
    public_ip_address_id = module.public_ip[each.value.public_ip_key].id
    subnet_id            = data.azurerm_subnet.gateway.id
  }
  additional_ip_configurations = [
    for cfg in each.value.additional_ip_configurations : {
      name                 = cfg.name
      public_ip_address_id = module.public_ip[cfg.public_ip_key].id
      subnet_id            = data.azurerm_subnet.gateway.id
    }
  ]
  vpn_client_configuration     = each.value.vpn_client_configuration
  tags                         = merge(var.common_tags, each.value.tags)

  depends_on = [module.public_ip]
}

module "expressroute_gateway" {
  for_each = var.expressroute_gateways
  source   = "../../../modules/networking/expressroute-gateway"

  name                = each.value.name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.network.name
  sku                 = each.value.sku
  ip_configuration = {
    name                 = each.value.ip_configuration.name
    public_ip_address_id = module.public_ip[each.value.public_ip_key].id
    subnet_id            = data.azurerm_subnet.gateway.id
  }
  tags = merge(var.common_tags, each.value.tags)

  depends_on = [module.public_ip]
}

module "application_gateway" {
  for_each = var.application_gateways
  source   = "../../../modules/networking/application-gateway"

  name                       = each.value.name
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.network.name
  sku                        = each.value.sku
  gateway_ip_configuration   = each.value.gateway_ip_configuration
  frontend_ports             = each.value.frontend_ports
  frontend_ip_configurations = each.value.frontend_ip_configurations
  backend_address_pools      = each.value.backend_address_pools
  backend_http_settings      = each.value.backend_http_settings
  http_listeners             = each.value.http_listeners
  request_routing_rules      = each.value.request_routing_rules
  waf_configuration          = each.value.waf_configuration
  tags                       = merge(var.common_tags, each.value.tags)
}

module "frontdoor" {
  for_each = var.frontdoors
  source   = "../../../modules/networking/frontdoor"

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.network.name
  sku_name            = each.value.sku_name
  identity            = each.value.identity
  endpoints           = each.value.endpoints
  waf_policy          = each.value.waf_policy
  tags                = merge(var.common_tags, each.value.tags)
}

module "load_balancer" {
  for_each = var.load_balancers
  source   = "../../../modules/networking/load-balancer"

  name                       = each.value.name
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.network.name
  sku                        = each.value.sku
  sku_tier                   = each.value.sku_tier
  frontend_ip_configuration  = each.value.frontend_ip_configuration
  tags                       = merge(var.common_tags, each.value.tags)
}

module "api_management" {
  for_each = var.api_managements
  source   = "../../../modules/networking/api-management"

  name                          = each.value.name
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.network.name
  publisher_name                = each.value.publisher_name
  publisher_email               = each.value.publisher_email
  sku_name                      = each.value.sku_name
  zones                         = each.value.zones
  identity                      = each.value.identity
  virtual_network_configuration = each.value.virtual_network_configuration
  protocols                     = each.value.protocols
  security                      = each.value.security
  sign_in                       = each.value.sign_in
  sign_up                       = each.value.sign_up
  tags                          = merge(var.common_tags, each.value.tags)
}

module "virtual_wan" {
  for_each = var.virtual_wans
  source   = "../../../modules/networking/virtual-wan"

  name               = each.value.name
  location           = var.location
  resource_group_name = data.azurerm_resource_group.network.name
  type               = each.value.type
  tags               = merge(var.common_tags, each.value.tags)
}
