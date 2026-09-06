output "id" {
  description = "Linux VMSS resource ID."
  value       = azurerm_linux_virtual_machine_scale_set.this.id
}

output "name" {
  description = "Linux VMSS name."
  value       = azurerm_linux_virtual_machine_scale_set.this.name
}

output "principal_id" {
  description = "System assigned identity principal ID, when enabled."
  value       = try(azurerm_linux_virtual_machine_scale_set.this.identity[0].principal_id, null)
}

output "unique_id" {
  description = "Linux VMSS unique ID."
  value       = azurerm_linux_virtual_machine_scale_set.this.unique_id
}
