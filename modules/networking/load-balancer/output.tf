output "id" {
  description = "Load balancer resource ID."
  value       = azurerm_lb.this.id
}

output "name" {
  description = "Load balancer name."
  value       = azurerm_lb.this.name
}

output "frontend_ip_configuration" {
  description = "Frontend IP configuration block."
  value       = azurerm_lb.this.frontend_ip_configuration
}
