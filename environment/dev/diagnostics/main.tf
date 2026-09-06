# Dev / diagnostics layer.
# Cross-layer diagnostic settings wired to central Log Analytics workspace.
locals {
  platform_diagnostic_settings = merge(
    var.enable_network_diagnostics ? {
      vnet_hub = {
        name               = "diag-vnet-hub"
        target_resource_id = data.azurerm_virtual_network.hub[0].id
        enabled_logs       = var.hub_vnet_enabled_logs
        metrics            = var.default_metrics
      }
    } : {},
    {
      for key, kv in data.azurerm_key_vault.platform : "kv_${key}" => {
        name               = "diag-${kv.name}"
        target_resource_id = kv.id
        enabled_logs       = var.key_vault_enabled_logs
        metrics            = var.default_metrics
      }
    },
    var.diagnostic_settings
  )
}

module "diagnostics" {
  for_each = local.platform_diagnostic_settings
  source   = "../../../modules/monitoring/diagnostics-settings"

  name                       = each.value.name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.platform.id
  enabled_logs               = each.value.enabled_logs
  metrics                    = each.value.metrics
}
