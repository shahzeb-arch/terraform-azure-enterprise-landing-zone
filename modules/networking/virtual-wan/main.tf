resource "azurerm_virtual_wan" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = var.type
  tags                = var.tags
}
