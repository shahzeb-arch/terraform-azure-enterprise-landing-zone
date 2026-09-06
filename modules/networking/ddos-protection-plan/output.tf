output "id" {
  description = "DDoS protection plan ID."
  value       = azurerm_network_ddos_protection_plan.this.id
}

output "name" {
  description = "DDoS protection plan name."
  value       = azurerm_network_ddos_protection_plan.this.name
}
