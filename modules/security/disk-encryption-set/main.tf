resource "azurerm_disk_encryption_set" "this" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  key_vault_key_id          = var.key_vault_key_id
  encryption_type           = var.encryption_type
  auto_key_rotation_enabled = var.auto_key_rotation_enabled
  federated_client_id       = var.federated_client_id
  tags                      = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}
