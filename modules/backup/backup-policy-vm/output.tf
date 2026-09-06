output "id" {
  description = "VM backup policy ID."
  value       = azurerm_backup_policy_vm.this.id
}

output "name" {
  description = "VM backup policy name."
  value       = azurerm_backup_policy_vm.this.name
}
