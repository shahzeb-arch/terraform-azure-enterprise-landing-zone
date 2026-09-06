output "id" {
  description = "Role assignment ID."
  value       = azurerm_role_assignment.this.id
}

output "principal_id" {
  description = "Principal object ID."
  value       = azurerm_role_assignment.this.principal_id
}

output "scope" {
  description = "Assignment scope."
  value       = azurerm_role_assignment.this.scope
}
