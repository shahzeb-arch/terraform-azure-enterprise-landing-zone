output "id" {
  description = "Availability set ID."
  value       = azurerm_availability_set.this.id
}

output "name" {
  description = "Availability set name."
  value       = azurerm_availability_set.this.name
}
