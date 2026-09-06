# Dev / sentinel layer.
# Onboards existing Log Analytics workspace to Microsoft Sentinel.
module "sentinel" {
  for_each = var.sentinel_onboarding
  source   = "../../../modules/monitoring/sentinel"

  workspace_id              = data.azurerm_log_analytics_workspace.this[each.value.workspace_lookup_key].id
  enable_aad_data_connector = each.value.enable_aad_data_connector
  aad_data_connector_name   = each.value.aad_data_connector_name
  tenant_id                 = coalesce(each.value.tenant_id, data.azurerm_client_config.current.tenant_id)
}
