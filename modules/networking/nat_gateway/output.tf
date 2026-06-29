output "id" {
  description = "NAT Gateway resource ID."
  value       = azurerm_nat_gateway.this.id
}

output "name" {
  description = "NAT Gateway name."
  value       = azurerm_nat_gateway.this.name
}

output "resource_guid" {
  description = "NAT Gateway resource GUID."
  value       = azurerm_nat_gateway.this.resource_guid
}
