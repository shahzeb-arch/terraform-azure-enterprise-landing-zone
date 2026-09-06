# Dev / governance layer.
# Policy assignments, RBAC, and subscription budgets (placeholder IDs for dev).
locals {
  subscription_id = coalesce(var.subscription_id, data.azurerm_subscription.current.id)
}

module "policy_assignment" {
  for_each = var.policy_assignments
  source   = "../../../modules/governence/policy-assignment"

  name                 = each.value.name
  display_name         = each.value.display_name
  policy_definition_id = each.value.policy_definition_id
  scope_type           = each.value.scope_type
  scope_id             = coalesce(each.value.scope_id, local.subscription_id)
  description          = each.value.description
  location             = each.value.location
  identity_type        = each.value.identity_type
  parameters           = each.value.parameters
  enforce              = each.value.enforce
}

module "role_assignment" {
  for_each = var.role_assignments
  source   = "../../../modules/governence/role-assignment"

  scope                            = each.value.scope
  principal_id                     = each.value.principal_id
  role_definition_name             = each.value.role_definition_name
  role_definition_id               = each.value.role_definition_id
  principal_type                   = each.value.principal_type
  description                      = each.value.description
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
}

module "budget" {
  for_each = var.budgets
  source   = "../../../modules/governence/budget"

  name            = each.value.name
  subscription_id = coalesce(each.value.subscription_id, local.subscription_id)
  amount          = each.value.amount
  time_grain      = each.value.time_grain
  time_period     = each.value.time_period
  notifications   = each.value.notifications
}
