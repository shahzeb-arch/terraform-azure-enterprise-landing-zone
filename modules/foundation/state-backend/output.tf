output "resource_group_name" {
  description = "State backend resource group name."
  value       = azurerm_resource_group.this.name
}

output "storage_account_name" {
  description = "State storage account name."
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "State storage account ID."
  value       = azurerm_storage_account.this.id
}

output "container_name" {
  description = "State blob container name."
  value       = azurerm_storage_container.this.name
}
