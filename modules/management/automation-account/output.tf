output "id" {
  description = "Automation account ID."
  value       = azurerm_automation_account.this.id
}

output "name" {
  description = "Automation account name."
  value       = azurerm_automation_account.this.name
}

output "identity" {
  description = "Managed identity block."
  value       = azurerm_automation_account.this.identity
}
