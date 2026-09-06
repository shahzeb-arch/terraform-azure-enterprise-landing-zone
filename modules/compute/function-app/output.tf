output "id" {
  description = "Function app ID."
  value       = azurerm_linux_function_app.this.id
}

output "name" {
  description = "Function app name."
  value       = azurerm_linux_function_app.this.name
}

output "default_hostname" {
  description = "Default hostname."
  value       = azurerm_linux_function_app.this.default_hostname
}

output "identity" {
  description = "Managed identity block."
  value       = azurerm_linux_function_app.this.identity
}
