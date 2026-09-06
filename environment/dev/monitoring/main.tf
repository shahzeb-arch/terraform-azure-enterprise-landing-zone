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

module "data_collection_rule" {
  for_each = var.data_collection_rules
  source   = "../../../modules/monitoring/data-collection-rule"

  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  description         = each.value.description
  destinations = {
    log_analytics = [
      for la in coalesce(each.value.destinations.log_analytics, []) : {
        name = la.name
        workspace_resource_id = coalesce(
          try(la.workspace_resource_id, null),
          module.log_analytics[la.workspace_key].id
        )
      }
    ]
    azure_monitor_metrics = coalesce(each.value.destinations.azure_monitor_metrics, [])
  }
  data_flows   = each.value.data_flows
  data_sources = each.value.data_sources
  tags         = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group, module.log_analytics]
}

module "metric_alert" {
  for_each = var.metric_alerts
  source   = "../../../modules/monitoring/alerts"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  scopes = coalesce(
    try(each.value.scopes, null),
    each.value.log_analytics_workspace_key != null ? [module.log_analytics[each.value.log_analytics_workspace_key].id] : []
  )
  description  = each.value.description
  severity     = each.value.severity
  frequency    = each.value.frequency
  window_size  = each.value.window_size
  enabled      = each.value.enabled
  auto_mitigate = each.value.auto_mitigate
  criteria     = each.value.criteria
  action_group_ids = [
    for ag_key in each.value.action_group_keys : module.action_group[ag_key].id
  ]
  tags = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group, module.action_group, module.log_analytics]
}
