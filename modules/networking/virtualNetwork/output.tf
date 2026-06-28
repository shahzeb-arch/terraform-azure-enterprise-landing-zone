output "resource_id" {
  value       = azurerm_virtual_network.this.id
  description = "Virtual Network resource ID."
}

output "name" {
  value       = azurerm_virtual_network.this.name
  description = "Virtual Network name."
}

output "address_space" {
  value       = azurerm_virtual_network.this.address_space
  description = "Address spaces assigned to the VNet."
}