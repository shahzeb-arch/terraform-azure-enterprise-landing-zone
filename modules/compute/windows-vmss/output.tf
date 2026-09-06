output "id" {
  description = "Windows VMSS ID."
  value       = azurerm_windows_virtual_machine_scale_set.this.id
}

output "name" {
  description = "Windows VMSS name."
  value       = azurerm_windows_virtual_machine_scale_set.this.name
}
