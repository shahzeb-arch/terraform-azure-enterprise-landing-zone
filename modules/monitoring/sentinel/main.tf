resource "azurerm_sentinel_log_analytics_workspace_onboarding" "this" {
  workspace_id = var.workspace_id
}

resource "azurerm_sentinel_data_connector_azure_active_directory" "this" {
  for_each = var.enable_aad_data_connector ? { default = true } : {}

  name                       = var.aad_data_connector_name
  log_analytics_workspace_id = var.workspace_id
  tenant_id                  = var.tenant_id
}
