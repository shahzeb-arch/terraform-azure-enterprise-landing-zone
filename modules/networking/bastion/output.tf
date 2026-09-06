output "id" {
  description = "Bastion host resource ID."
  value       = azurerm_bastion_host.this.id
}

output "name" {
  description = "Bastion host name."
  value       = azurerm_bastion_host.this.name
}

output "dns_name" {
  description = "Bastion FQDN."
  value       = azurerm_bastion_host.this.dns_name
}
