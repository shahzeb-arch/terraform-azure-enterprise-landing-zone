resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = var.private_dns_zone_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  registration_enabled = var.registration_enabled
  resolution_policy = var.resolution_policy
  tags = var.tags
}