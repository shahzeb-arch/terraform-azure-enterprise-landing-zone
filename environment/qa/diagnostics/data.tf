data "azurerm_log_analytics_workspace" "platform" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_resource_group_name
}

data "azurerm_resource_group" "network" {
  count = var.enable_network_diagnostics ? 1 : 0

  name = var.network_resource_group_name
}

data "azurerm_virtual_network" "hub" {
  count = var.enable_network_diagnostics ? 1 : 0

  name                = var.hub_vnet_name
  resource_group_name = data.azurerm_resource_group.network[0].name
}

data "azurerm_key_vault" "platform" {
  for_each = var.key_vault_lookups

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}
