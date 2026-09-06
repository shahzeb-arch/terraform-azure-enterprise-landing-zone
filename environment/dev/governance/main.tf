# Dev / governance layer (Microsoft ALZ-aligned).
# Foundation + governance in one layer:
# - Management group hierarchy
# - Subscription creation and/or placement (one sub per platform MG)
# - Policy definitions, initiatives, assignments, RBAC, budgets, locks

locals {
  subscription_id = coalesce(var.subscription_id, data.azurerm_subscription.current.id)

  management_groups_root = {
    for key, cfg in var.management_groups : key => cfg
    if try(cfg.parent_management_group_key, null) == null
  }

  management_groups_child = {
    for key, cfg in var.management_groups : key => cfg
    if try(cfg.parent_management_group_key, null) != null
  }

  all_management_group_ids = merge(
    { for k, m in module.management_group_root : k => m.id },
    { for k, m in module.management_group_child : k => m.id }
  )

  policy_assignment_scopes = {
    for key, cfg in var.policy_assignments : key => coalesce(
      try(cfg.scope_id, null),
      cfg.scope_type == "management_group" && try(cfg.management_group_key, null) != null ? local.all_management_group_ids[cfg.management_group_key] : null,
      cfg.scope_type == "subscription" && try(cfg.subscription_key, null) != null ? try(module.subscription[cfg.subscription_key].subscription_id, var.subscription_placements[cfg.subscription_key].subscription_id) : null,
      local.subscription_id
    )
  }
}

# --- Foundation: organization ---

module "management_group_root" {
  for_each = local.management_groups_root
  source   = "../../../modules/foundation/management-group"

  name                       = each.key
  display_name               = each.value.display_name
  parent_management_group_id = coalesce(try(each.value.parent_management_group_id, null), var.tenant_root_management_group_id)
}

module "management_group_child" {
  for_each = local.management_groups_child
  source   = "../../../modules/foundation/management-group"

  name                       = each.key
  display_name               = each.value.display_name
  parent_management_group_id = coalesce(
    try(each.value.parent_management_group_id, null),
    module.management_group_root[each.value.parent_management_group_key].id
  )

  depends_on = [module.management_group_root]
}

module "subscription" {
  for_each = var.subscriptions
  source   = "../../../modules/foundation/subscription"

  subscription_name = each.value.subscription_name
  alias             = each.value.alias
  billing_scope_id  = data.azurerm_billing_mca_account_scope.this[each.value.billing_scope_key].id
  tags              = merge(var.common_tags, each.value.tags)
}

module "management_group_subscription_association" {
  for_each = var.subscriptions
  source   = "../../../modules/foundation/management-group-subs-association"

  management_group_id = local.all_management_group_ids[each.value.target_management_group_key]
  subscription_id     = module.subscription[each.key].id

  depends_on = [module.management_group_root, module.management_group_child, module.subscription]
}

module "subscription_placement" {
  for_each = var.subscription_placements
  source   = "../../../modules/foundation/management-group-subs-association"

  management_group_id = local.all_management_group_ids[each.value.target_management_group_key]
  subscription_id     = each.value.subscription_id

  depends_on = [module.management_group_root, module.management_group_child]
}

module "management_lock" {
  for_each = var.management_locks
  source   = "../../../modules/foundation/management-lock"

  name       = each.value.name
  scope      = each.value.scope
  lock_level = each.value.lock_level
  notes      = each.value.notes
}

# --- Governance: policy & access ---

module "policy" {
  for_each = var.policies
  source   = "../../../modules/governence/policy"

  name                = each.value.name
  policy_type         = each.value.policy_type
  mode                = each.value.mode
  display_name        = each.value.display_name
  description         = each.value.description
  policy_rule         = each.value.policy_rule
  metadata            = each.value.metadata
  parameters          = each.value.parameters
  management_group_id = try(each.value.management_group_key != null ? local.all_management_group_ids[each.value.management_group_key] : each.value.management_group_id, each.value.management_group_id)
}

module "initiative" {
  for_each = var.initiatives
  source   = "../../../modules/governence/initiative"

  name                         = each.value.name
  display_name                 = each.value.display_name
  description                  = each.value.description
  policy_type                  = each.value.policy_type
  management_group_id          = try(each.value.management_group_key != null ? local.all_management_group_ids[each.value.management_group_key] : each.value.management_group_id, each.value.management_group_id)
  policy_definition_references = each.value.policy_definition_references
  policy_definition_groups     = each.value.policy_definition_groups
  parameters                   = each.value.parameters
  metadata                     = each.value.metadata
}

module "policy_assignment" {
  for_each = var.policy_assignments
  source   = "../../../modules/governence/policy-assignment"

  name                 = each.value.name
  display_name         = each.value.display_name
  policy_definition_id = each.value.policy_definition_id
  scope_type           = each.value.scope_type
  scope_id             = local.policy_assignment_scopes[each.key]
  description          = each.value.description
  location             = each.value.location
  identity_type        = each.value.identity_type
  parameters           = each.value.parameters
  enforce              = each.value.enforce

  depends_on = [module.management_group_root, module.management_group_child, module.subscription, module.subscription_placement]
}

module "role_definition" {
  for_each = var.role_definitions
  source   = "../../../modules/governence/role-definition"

  name              = each.value.name
  scope             = each.value.scope
  description       = each.value.description
  permissions       = each.value.permissions
  assignable_scopes = coalesce(each.value.assignable_scopes, [each.value.scope])
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
  subscription_id = coalesce(
    try(each.value.subscription_id, null),
    try(each.value.subscription_key != null ? module.subscription[each.value.subscription_key].subscription_id : null, null),
    try(each.value.subscription_key != null ? var.subscription_placements[each.value.subscription_key].subscription_id : null, null),
    local.subscription_id
  )
  amount          = each.value.amount
  time_grain      = each.value.time_grain
  time_period     = each.value.time_period
  notifications   = each.value.notifications
}
