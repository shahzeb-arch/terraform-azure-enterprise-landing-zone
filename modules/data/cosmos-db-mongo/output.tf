output "id" {
  description = "Cosmos DB account ID."
  value       = azurerm_cosmosdb_account.this.id
}

output "name" {
  description = "Cosmos DB account name."
  value       = azurerm_cosmosdb_account.this.name
}

output "endpoint" {
  description = "Cosmos DB endpoint."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_mongodb_connection_string" {
  description = "Primary MongoDB connection string."
  value       = azurerm_cosmosdb_account.this.primary_mongodb_connection_string
  sensitive   = true
}
