output "id" {
  description = "ExpressRoute gateway ID."
  value       = azurerm_virtual_network_gateway.this.id
}

output "name" {
  description = "ExpressRoute gateway name."
  value       = azurerm_virtual_network_gateway.this.name
}
