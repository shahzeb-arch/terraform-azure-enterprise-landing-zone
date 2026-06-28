resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = var.service_endpoints
  dynamic "delegation" {
    for_each = var.delegation != null ? [var.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.service_actions
      }
    }
  }
  default_outbound_access_enabled               = var.default_outbound_access_enabled
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = var.service_endpoint_policy_ids
  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = var.timeouts.create
      delete = var.timeouts.delete
      read   = var.timeouts.read
      update = var.timeouts.update
    }
  }
}
