# Databricks Workspace

## What it is
Azure Databricks analytics workspace for Spark/ML workloads.

## Resources created
- azurerm_databricks_workspace

## Production notes
- Use Premium SKU with VNet injection (`custom_parameters`).
- Set `no_public_ip = true` for secure cluster nodes.
