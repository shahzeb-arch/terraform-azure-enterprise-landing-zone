# Microsoft Sentinel

## What it is
Onboards a Log Analytics workspace to Microsoft Sentinel and optionally connects Azure AD sign-in and audit logs.

## When to use it (production)
- Deploy after Log Analytics workspace is provisioned.
- Enable AAD connector for identity threat detection.
- Restrict workspace internet access in production.

## Resources created
- `azurerm_sentinel_log_analytics_workspace_onboarding`
- `azurerm_sentinel_data_connector_azure_active_directory` (optional)

## Usage example
```hcl
module "sentinel" {
  source                    = "../../modules/monitoring/sentinel"
  workspace_id              = module.log_analytics.id
  enable_aad_data_connector = true
  tenant_id                 = data.azurerm_client_config.current.tenant_id
}
```

## Production notes
- Sentinel requires SecurityInsights solution on the workspace.
- Use data connectors for additional telemetry (Defender, Azure Activity).
