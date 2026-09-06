resource "azurerm_lb" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  sku_tier            = var.sku_tier
  tags                = var.tags

  frontend_ip_configuration {
    name                          = var.frontend_ip_configuration.name
    subnet_id                     = var.frontend_ip_configuration.subnet_id
    private_ip_address            = var.frontend_ip_configuration.private_ip_address
    private_ip_address_allocation = var.frontend_ip_configuration.private_ip_address_allocation
    private_ip_address_version    = var.frontend_ip_configuration.private_ip_address_version
    public_ip_address_id          = var.frontend_ip_configuration.public_ip_address_id
    zones                         = var.frontend_ip_configuration.zones
  }
}
