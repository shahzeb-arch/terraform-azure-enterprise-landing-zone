output "id" {
  description = "Role definition resource ID."
  value       = azurerm_role_definition.this.role_definition_resource_id
}

output "name" {
  description = "Role definition name."
  value       = azurerm_role_definition.this.name
}
