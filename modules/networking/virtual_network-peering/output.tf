output "id" {
  description = "VNet peering ID."
  value       = azurerm_virtual_network_peering.this.id
}

output "name" {
  description = "VNet peering name."
  value       = azurerm_virtual_network_peering.this.name
}
