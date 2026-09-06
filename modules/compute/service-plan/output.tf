output "id" {
  description = "Service plan ID."
  value       = azurerm_service_plan.this.id
}

output "name" {
  description = "Service plan name."
  value       = azurerm_service_plan.this.name
}
