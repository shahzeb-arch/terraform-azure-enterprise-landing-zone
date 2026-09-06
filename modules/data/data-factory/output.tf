output "id" {
  description = "Data Factory ID."
  value       = azurerm_data_factory.this.id
}

output "name" {
  description = "Data Factory name."
  value       = azurerm_data_factory.this.name
}

output "identity" {
  description = "Managed identity block."
  value       = azurerm_data_factory.this.identity
}
