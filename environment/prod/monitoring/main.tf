# Dev / monitoring layer.
# Log Analytics workspaces and action groups for platform observability.
module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/foundation/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "log_analytics" {
  for_each = var.log_analytics_workspaces
  source   = "../../../modules/monitoring/log-analytics"

  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = module.resource_group[each.value.resource_group_key].name
  sku                        = each.value.sku
  retention_in_days          = each.value.retention_in_days
  daily_quota_gb             = each.value.daily_quota_gb
  internet_ingestion_enabled = each.value.internet_ingestion_enabled
  internet_query_enabled     = each.value.internet_query_enabled
  tags                       = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "action_group" {
  for_each = var.action_groups
  source   = "../../../modules/monitoring/action-group"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  short_name          = each.value.short_name
  enabled             = each.value.enabled
  email_receivers     = each.value.email_receivers
  tags                = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}
