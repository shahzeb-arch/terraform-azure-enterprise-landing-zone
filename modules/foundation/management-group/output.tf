output "id" {
  description = "Management group resource ID."
  value       = azurerm_management_group.this.id
}

output "name" {
  description = "Management group name."
  value       = azurerm_management_group.this.name
}

output "display_name" {
  description = "Management group display name."
  value       = azurerm_management_group.this.display_name
}

output "parent_management_group_id" {
  description = "Parent management group resource ID."
  value       = azurerm_management_group.this.parent_management_group_id
}