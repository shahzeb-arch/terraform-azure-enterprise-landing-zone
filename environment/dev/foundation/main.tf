module "management_group" {
  for_each = var.management_groups
  source   = "../../../modules/foundation/management-group"

  name         = each.key
  display_name = each.value.display_name
  parent_management_group_id = coalesce(
    each.value.parent_management_group_id,
    var.tenant_root_management_group_id
  )
}

module "subscription" {
  for_each = var.subscriptions
  source   = "../../../modules/foundation/subscription"

  subscription_name = each.value.subscription_name
  alias             = each.value.alias
  billing_scope_id  = data.azurerm_billing_mca_account_scope.this[each.value.billing_scope_key].id
  tags              = each.value.tags
}

module "management_group_subscription_association" {
  for_each = var.subscriptions
  source   = "../../../modules/foundation/management-group-subs-association"

  management_group_id = module.management_group[each.value.target_management_group_key].id
  subscription_id     = module.subscription[each.key].id
}
