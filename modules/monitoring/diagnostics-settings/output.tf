output "id" {
  description = "Diagnostic setting ID."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "name" {
  description = "Diagnostic setting name."
  value       = azurerm_monitor_diagnostic_setting.this.name
}
