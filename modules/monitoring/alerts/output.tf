output "id" {
  description = "Alert ID."
  value       = azurerm_monitor_metric_alert.this.id
}

output "name" {
  description = "Alert name."
  value       = azurerm_monitor_metric_alert.this.name
}
