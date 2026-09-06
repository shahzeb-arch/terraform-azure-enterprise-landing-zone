resource "azurerm_network_interface" "this" {
  name                           = var.name
  resource_group_name            = var.resource_group_name
  location                       = var.location
  accelerated_networking_enabled = var.accelerated_networking_enabled
  dns_servers                    = var.dns_servers
  internal_dns_name_label        = var.internal_dns_name_label
  ip_forwarding_enabled          = var.ip_forwarding_enabled
  tags                           = var.tags

  ip_configuration {
    name                          = var.ip_configuration.name
    subnet_id                     = var.ip_configuration.subnet_id
    private_ip_address_allocation = var.ip_configuration.private_ip_address_allocation
    private_ip_address            = var.ip_configuration.private_ip_address
    public_ip_address_id          = var.ip_configuration.public_ip_address_id
    primary                       = true
  }
}
