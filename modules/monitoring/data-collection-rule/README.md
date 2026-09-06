# Data Collection Rule

## What it is
Azure Monitor Data Collection Rule (DCR) for agentless or agent-based telemetry routing to Log Analytics.

## When to use it (production)
- Standardize VM and AKS monitoring data flows to central workspace.
- Use transform_kql to reduce ingestion volume.

## Resources created
- `azurerm_monitor_data_collection_rule`

## Usage example
```hcl
module "dcr" {
  source              = "../../modules/monitoring/data-collection-rule"
  name                = "dcr-platform-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-monitoring"
  destinations = {
    log_analytics = [{
      name                  = "central"
      workspace_resource_id = module.log_analytics.id
    }]
  }
}
```

## Production notes
- Associate DCR with VMs or AKS via data collection rule associations.
- Align streams with Azure Monitor agent requirements.
