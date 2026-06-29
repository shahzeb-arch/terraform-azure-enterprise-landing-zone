output "id" {
  description = "Subscription resource ID."
  value       = azurerm_subscription.this.id
}

output "subscription_id" {
  description = "Created subscription GUID."
  value       = azurerm_subscription.this.subscription_id
}

output "subscription_name" {
  description = "Subscription name."
  value       = azurerm_subscription.this.subscription_name
}
