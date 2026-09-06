resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = var.vpn_type
  sku                 = var.sku
  active_active       = var.active_active
  enable_bgp          = var.enable_bgp
  tags                = var.tags

  ip_configuration {
    name                          = var.ip_configuration.name
    public_ip_address_id          = var.ip_configuration.public_ip_address_id
    private_ip_address_allocation = var.ip_configuration.private_ip_address_allocation
    subnet_id                     = var.ip_configuration.subnet_id
  }

  dynamic "ip_configuration" {
    for_each = var.additional_ip_configurations
    content {
      name                          = ip_configuration.value.name
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      subnet_id                     = ip_configuration.value.subnet_id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration != null ? [var.vpn_client_configuration] : []
    content {
      address_space        = vpn_client_configuration.value.address_space
      vpn_client_protocols = vpn_client_configuration.value.vpn_client_protocols
      vpn_auth_types       = vpn_client_configuration.value.vpn_auth_types
    }
  }
}
