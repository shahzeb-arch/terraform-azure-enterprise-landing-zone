variable "name" {
  type        = string
  description = "Disk encryption set name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "key_vault_key_id" {
  type        = string
  description = "Key Vault key version URI for CMK."
}

variable "encryption_type" {
  type        = string
  description = "EncryptionType: EncryptionAtRestWithCustomerKey."
  default     = "EncryptionAtRestWithCustomerKey"
}

variable "auto_key_rotation_enabled" {
  type        = bool
  description = "Enable automatic key rotation."
  default     = true
}

variable "federated_client_id" {
  type        = string
  description = "Multi-tenant application client ID for key vault access."
  default     = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity for Key Vault key access."
  default = {
    type = "SystemAssigned"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
