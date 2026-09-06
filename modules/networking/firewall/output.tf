output "id" {
  description = "Firewall resource ID."
  value       = azurerm_firewall.this.id
}

output "name" {
  description = "Firewall name."
  value       = azurerm_firewall.this.name
}

output "private_ip_address" {
  description = "Firewall private IP in AzureFirewallSubnet."
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}
