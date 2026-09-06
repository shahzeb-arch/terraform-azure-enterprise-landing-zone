output "id" {
  description = "Key Vault key ID."
  value       = azurerm_key_vault_key.this.id
}

output "name" {
  description = "Key name."
  value       = azurerm_key_vault_key.this.name
}

output "versionless_id" {
  description = "Versionless key ID (for disk encryption sets)."
  value       = azurerm_key_vault_key.this.versionless_id
}

output "resource_id" {
  description = "Key resource ID."
  value       = azurerm_key_vault_key.this.resource_id
}

output "resource_versionless_id" {
  description = "Versionless resource ID."
  value       = azurerm_key_vault_key.this.resource_versionless_id
}
