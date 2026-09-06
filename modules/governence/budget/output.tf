output "id" {
  description = "Budget resource ID."
  value       = azurerm_consumption_budget_subscription.this.id
}

output "name" {
  description = "Budget name."
  value       = azurerm_consumption_budget_subscription.this.name
}
