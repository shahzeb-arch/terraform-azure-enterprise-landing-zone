data "azurerm_resource_group" "hub" {
  name = var.hub_resource_group_name
}

data "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  resource_group_name = data.azurerm_resource_group.hub.name
}
