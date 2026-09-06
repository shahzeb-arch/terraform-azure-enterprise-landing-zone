output "id" {
  description = "Management lock ID."
  value       = azurerm_management_lock.this.id
}

output "name" {
  description = "Management lock name."
  value       = azurerm_management_lock.this.name
}
