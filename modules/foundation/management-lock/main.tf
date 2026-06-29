resource "azurerm_management_lock" "resource-group-level" {
  name       = "resource-group-level"
  scope      = azurerm_resource_group.example.id
  lock_level = "ReadOnly"
  notes      = "This Resource Group is Read-Only"
}

resource "azurerm_management_lock" "subscription-level" {
  name       = "subscription-level"
  scope      = data.azurerm_subscription.current.id
  lock_level = "CanNotDelete"
  notes      = "Items can't be deleted in this subscription!"
}

resource "azurerm_management_lock" "public-ip" {
  name       = "resource-ip"
  scope      = azurerm_public_ip.example.id
  lock_level = "CanNotDelete"
  notes      = "Locked because it's needed by a third-party"
}

