output "id" {
  description = "Web app ID."
  value       = azurerm_linux_web_app.this.id
}

output "name" {
  description = "Web app name."
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "Default hostname."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "identity" {
  description = "Managed identity block."
  value       = azurerm_linux_web_app.this.identity
}
