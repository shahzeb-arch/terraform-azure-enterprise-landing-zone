variable "name" {
  type        = string
  description = "Site Recovery replication policy name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "recovery_vault_name" {
  type        = string
  description = "Recovery Services Vault name."
}

variable "recovery_point_retention_in_minutes" {
  type        = number
  description = "Recovery point retention in minutes."
  default     = 1440
}

variable "application_consistent_snapshot_frequency_in_minutes" {
  type        = number
  description = "App-consistent snapshot frequency in minutes."
  default     = 240
}
