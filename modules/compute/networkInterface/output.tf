output "id" {
  description = "Network interface ID."
  value       = azurerm_network_interface.this.id
}

output "name" {
  description = "Network interface name."
  value       = azurerm_network_interface.this.name
}

output "private_ip_address" {
  description = "Private IP address assigned to the NIC."
  value       = azurerm_network_interface.this.private_ip_address
}
