output "id" {
  description = "VPN gateway ID."
  value       = azurerm_virtual_network_gateway.this.id
}

output "name" {
  description = "VPN gateway name."
  value       = azurerm_virtual_network_gateway.this.name
}
