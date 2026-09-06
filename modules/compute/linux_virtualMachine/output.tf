output "id" {
  description = "Linux VM resource ID."
  value       = azurerm_linux_virtual_machine.this.id
}

output "name" {
  description = "Linux VM name."
  value       = azurerm_linux_virtual_machine.this.name
}

output "private_ip_address" {
  description = "Primary private IP address."
  value       = azurerm_linux_virtual_machine.this.private_ip_address
}

output "principal_id" {
  description = "System assigned identity principal ID, when enabled."
  value       = try(azurerm_linux_virtual_machine.this.identity[0].principal_id, null)
}
