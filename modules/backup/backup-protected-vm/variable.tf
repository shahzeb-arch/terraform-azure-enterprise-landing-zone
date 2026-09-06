variable "resource_group_name" {
  type        = string
  description = "Resource group containing the Recovery Services Vault."
}

variable "recovery_vault_name" {
  type        = string
  description = "Recovery Services Vault name."
}

variable "source_vm_id" {
  type        = string
  description = "Azure VM resource ID to protect."
}

variable "backup_policy_id" {
  type        = string
  description = "Backup policy ID from backup-policy-vm module."
}
