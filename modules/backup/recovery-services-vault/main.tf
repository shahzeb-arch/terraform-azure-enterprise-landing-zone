resource "azurerm_recovery_services_vault" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  soft_delete_enabled           = var.soft_delete_enabled
  public_network_access_enabled = var.public_network_access_enabled
  cross_region_restore_enabled  = var.cross_region_restore_enabled
  storage_mode_type             = var.storage_mode_type
  tags                          = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}
