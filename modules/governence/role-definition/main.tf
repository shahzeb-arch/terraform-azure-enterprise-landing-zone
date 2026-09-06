resource "azurerm_role_definition" "this" {
  name        = var.name
  scope       = var.scope
  description = var.description

  permissions {
    actions          = var.permissions.actions
    not_actions      = var.permissions.not_actions
    data_actions     = var.permissions.data_actions
    not_data_actions = var.permissions.not_data_actions
  }

  assignable_scopes = var.assignable_scopes
}
