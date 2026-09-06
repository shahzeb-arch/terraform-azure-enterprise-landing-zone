output "id" {
  description = "Subnet resource ID."
  value       = azurerm_subnet.this.id
}

output "name" {
  description = "Subnet name."
  value       = azurerm_subnet.this.name
}

output "address_prefixes" {
  description = "Address prefixes assigned to the subnet."
  value       = azurerm_subnet.this.address_prefixes
}
