resource "azurerm_subscription_policy_assignment" "this" {
  count = var.scope_type == "subscription" ? 1 : 0

  name                 = var.name
  display_name         = var.display_name
  description          = var.description
  policy_definition_id = var.policy_definition_id
  subscription_id      = var.scope_id
  location             = var.location
  identity {
    type = var.identity_type
  }
  parameters = var.parameters
  metadata   = var.metadata
  enforce    = var.enforce
}

resource "azurerm_resource_group_policy_assignment" "this" {
  count = var.scope_type == "resource_group" ? 1 : 0

  name                 = var.name
  display_name         = var.display_name
  description          = var.description
  policy_definition_id = var.policy_definition_id
  resource_group_id    = var.scope_id
  location             = var.location
  identity {
    type = var.identity_type
  }
  parameters = var.parameters
  metadata   = var.metadata
  enforce    = var.enforce
}

resource "azurerm_management_group_policy_assignment" "this" {
  count = var.scope_type == "management_group" ? 1 : 0

  name                 = var.name
  display_name         = var.display_name
  description          = var.description
  policy_definition_id = var.policy_definition_id
  management_group_id  = var.scope_id
  location             = var.location
  identity {
    type = var.identity_type
  }
  parameters = var.parameters
  metadata   = var.metadata
  enforce    = var.enforce
}
