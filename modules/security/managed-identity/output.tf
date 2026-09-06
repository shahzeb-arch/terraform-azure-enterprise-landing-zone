output "id" {
  description = "Managed identity resource ID."
  value       = azurerm_user_assigned_identity.this.id
}

output "name" {
  description = "Managed identity name."
  value       = azurerm_user_assigned_identity.this.name
}

output "principal_id" {
  description = "Service principal object ID for RBAC assignments."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client ID for application authentication."
  value       = azurerm_user_assigned_identity.this.client_id
}
