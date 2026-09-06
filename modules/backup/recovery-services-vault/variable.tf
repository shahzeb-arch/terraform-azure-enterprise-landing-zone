variable "name" {
  type        = string
  description = "Recovery Services Vault name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku" {
  type        = string
  description = "Standard is required for VM backup and ASR."
  default     = "Standard"
}

variable "soft_delete_enabled" {
  type        = bool
  description = "Enable soft delete for backup data."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Disable public access for production ELZ."
  default     = false
}

variable "cross_region_restore_enabled" {
  type        = bool
  description = "Enable cross-region restore for GRS vaults."
  default     = true
}

variable "storage_mode_type" {
  type        = string
  description = "GeoRedundant or LocallyRedundant."
  default     = "GeoRedundant"
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity for CMK or backup encryption."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
