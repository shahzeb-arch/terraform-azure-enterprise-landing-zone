output "subnet_association_id" {
  description = "ID of the subnet to NAT Gateway association."
  value       = azurerm_subnet_nat_gateway_association.this.id
}

output "public_ip_association_ids" {
  description = "Map of public IP to NAT Gateway association IDs."
  value       = { for k, m in azurerm_nat_gateway_public_ip_association.this : k => m.id }
}
