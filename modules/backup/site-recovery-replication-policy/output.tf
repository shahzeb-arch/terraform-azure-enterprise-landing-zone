output "id" {
  description = "Site Recovery replication policy ID."
  value       = azurerm_site_recovery_replication_policy.this.id
}

output "name" {
  description = "Site Recovery replication policy name."
  value       = azurerm_site_recovery_replication_policy.this.name
}
