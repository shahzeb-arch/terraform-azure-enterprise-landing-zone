output "id" {
  description = "API Management ID."
  value       = azurerm_api_management.this.id
}

output "name" {
  description = "API Management name."
  value       = azurerm_api_management.this.name
}

output "gateway_url" {
  description = "Gateway URL."
  value       = azurerm_api_management.this.gateway_url
}

output "developer_portal_url" {
  description = "Developer portal URL."
  value       = azurerm_api_management.this.developer_portal_url
}

output "identity" {
  description = "Managed identity block."
  value       = azurerm_api_management.this.identity
}
