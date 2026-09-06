output "id" {
  description = "Disk encryption set ID."
  value       = azurerm_disk_encryption_set.this.id
}

output "identity" {
  description = "Managed identity block."
  value       = azurerm_disk_encryption_set.this.identity
}
