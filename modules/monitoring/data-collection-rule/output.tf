output "id" {
  description = "Data collection rule ID."
  value       = azurerm_monitor_data_collection_rule.this.id
}

output "name" {
  description = "Data collection rule name."
  value       = azurerm_monitor_data_collection_rule.this.name
}
