resource "azurerm_resource_management_private_link" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}
