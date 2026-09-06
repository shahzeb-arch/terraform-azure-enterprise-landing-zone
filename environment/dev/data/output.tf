output "resource_group_ids" {
  description = "Data layer resource group IDs."
  value       = { for k, m in module.resource_group : k => m.id }
}

output "storage_account_ids" {
  description = "Storage account IDs."
  value       = { for k, m in module.storage_account : k => m.id }
}

output "storage_account_names" {
  description = "Storage account names."
  value       = { for k, m in module.storage_account : k => m.name }
}

output "data_factory_ids" {
  description = "Data Factory IDs."
  value       = { for k, m in module.data_factory : k => m.id }
}

output "redis_cache_ids" {
  description = "Redis cache IDs."
  value       = { for k, m in module.redis_cache : k => m.id }
}

output "sql_server_ids" {
  description = "SQL server IDs."
  value       = { for k, m in module.sql_server : k => m.id }
}

output "sql_database_ids" {
  description = "SQL database IDs."
  value       = { for k, m in module.sql_database : k => m.id }
}

output "cosmos_db_mongo_ids" {
  description = "Cosmos DB Mongo account IDs."
  value       = { for k, m in module.cosmos_db_mongo : k => m.id }
}

output "postgresql_flexible_server_ids" {
  description = "PostgreSQL flexible server IDs."
  value       = { for k, m in module.postgresql_flexible_server : k => m.id }
}

output "databricks_workspace_ids" {
  description = "Databricks workspace IDs."
  value       = { for k, m in module.databricks_workspace : k => m.id }
}
