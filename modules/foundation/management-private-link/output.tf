output "id" {
  description = "Resource management private link ID."
  value       = azurerm_resource_management_private_link.this.id
}

output "name" {
  description = "Resource management private link name."
  value       = azurerm_resource_management_private_link.this.name
}
