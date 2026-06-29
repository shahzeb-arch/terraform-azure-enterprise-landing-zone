output "id" {
  description = "Private DNS Zone resource ID."
  value       = azurerm_private_dns_zone.this.id
}

output "name" {
  description = "Private DNS Zone name."
  value       = azurerm_private_dns_zone.this.name
}
