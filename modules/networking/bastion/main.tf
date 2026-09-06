resource "azurerm_bastion_host" "this" {
  name                   = var.name
  location               = var.location
  resource_group_name    = var.resource_group_name
  sku                    = var.sku
  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.file_copy_enabled
  ip_connect_enabled     = var.ip_connect_enabled
  shareable_link_enabled = var.shareable_link_enabled
  tunneling_enabled      = var.tunneling_enabled
  tags                   = var.tags

  ip_configuration {
    name                 = var.ip_configuration.name
    subnet_id            = var.ip_configuration.subnet_id
    public_ip_address_id = var.ip_configuration.public_ip_address_id
  }
}
