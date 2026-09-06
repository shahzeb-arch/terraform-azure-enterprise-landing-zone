resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "ExpressRoute"
  sku                 = var.sku
  tags                = var.tags

  ip_configuration {
    name                          = var.ip_configuration.name
    public_ip_address_id          = var.ip_configuration.public_ip_address_id
    private_ip_address_allocation = var.ip_configuration.private_ip_address_allocation
    subnet_id                     = var.ip_configuration.subnet_id
  }
}
