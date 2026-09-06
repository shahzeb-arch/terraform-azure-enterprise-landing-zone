output "resource_group_ids" {
  description = "Security resource group IDs."
  value       = { for k, m in module.resource_group : k => m.id }
}

output "key_vault_ids" {
  description = "Key Vault IDs."
  value       = { for k, m in module.key_vault : k => m.id }
}

output "managed_identity_ids" {
  description = "Managed identity IDs."
  value       = { for k, m in module.managed_identity : k => m.id }
}

output "managed_identity_principal_ids" {
  description = "Managed identity principal IDs."
  value       = { for k, m in module.managed_identity : k => m.principal_id }
}

output "lock_ids" {
  description = "Management lock IDs."
  value       = { for k, m in module.lock : k => m.id }
}

output "defender_resource_types" {
  description = "Enabled Defender resource types."
  value       = var.defender_plans != null ? module.defender[0].resource_types : []
}
