output "onboarding_id" {
  description = "Sentinel onboarding resource ID."
  value       = azurerm_sentinel_log_analytics_workspace_onboarding.this.id
}

output "aad_data_connector_id" {
  description = "Azure AD data connector ID when enabled."
  value       = try(azurerm_sentinel_data_connector_azure_active_directory.this["default"].id, null)
}
