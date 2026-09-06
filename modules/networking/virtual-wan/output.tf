output "id" {
  description = "Virtual WAN ID."
  value       = azurerm_virtual_wan.this.id
}

output "name" {
  description = "Virtual WAN name."
  value       = azurerm_virtual_wan.this.name
}
