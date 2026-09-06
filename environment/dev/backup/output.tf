output "resource_group_ids" {
  description = "Backup layer resource group IDs."
  value       = { for k, m in module.resource_group : k => m.id }
}

output "recovery_services_vault_ids" {
  description = "Recovery Services Vault IDs."
  value       = { for k, m in module.recovery_services_vault : k => m.id }
}

output "backup_policy_vm_ids" {
  description = "VM backup policy IDs."
  value       = { for k, m in module.backup_policy_vm : k => m.id }
}

output "backup_protected_vm_ids" {
  description = "Protected VM backup item IDs."
  value       = { for k, m in module.backup_protected_vm : k => m.id }
}

output "site_recovery_replication_policy_ids" {
  description = "ASR replication policy IDs."
  value       = { for k, m in module.site_recovery_replication_policy : k => m.id }
}
