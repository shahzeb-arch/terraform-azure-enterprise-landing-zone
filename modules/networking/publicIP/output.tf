output "id" {
  description = "Public IP resource ID."
  value       = azurerm_public_ip.this.id
}

output "name" {
  description = "Public IP name."
  value       = azurerm_public_ip.this.name
}

output "ip_address" {
  description = "The allocated public IP address (populated once assigned)."
  value       = azurerm_public_ip.this.ip_address
}

output "fqdn" {
  description = "The FQDN of the Public IP, if a domain name label is set."
  value       = azurerm_public_ip.this.fqdn
}
