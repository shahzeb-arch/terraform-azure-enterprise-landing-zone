# Dev / management layer.
# Automation accounts for platform runbooks and update management.
module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/foundation/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "automation_account" {
  for_each = var.automation_accounts
  source   = "../../../modules/management/automation-account"

  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  sku_name            = each.value.sku_name
  identity            = each.value.identity
  tags                = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}
