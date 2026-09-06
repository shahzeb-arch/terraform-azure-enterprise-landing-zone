variable "name" {
  type        = string
  description = "PostgreSQL flexible server name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "administrator_login" {
  type        = string
  description = "Admin login."
}

variable "administrator_password" {
  type        = string
  description = "Admin password."
  sensitive   = true
}

variable "server_version" {
  type        = string
  description = "PostgreSQL version."
  default     = "16"
}

variable "sku_name" {
  type        = string
  description = "SKU name (e.g. GP_Standard_D2s_v3)."
  default     = "GP_Standard_D2s_v3"
}

variable "storage_mb" {
  type        = number
  description = "Storage size in MB."
  default     = 32768
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention in days."
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Enable geo-redundant backup."
  default     = true
}

variable "zone" {
  type        = string
  description = "Availability zone."
  default     = "1"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public network access."
  default     = false
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration."
  default     = null
}

variable "authentication" {
  type = object({
    active_directory_auth_enabled = optional(bool, true)
    password_auth_enabled         = optional(bool, true)
  })
  description = "Authentication settings."
  default     = null
}

variable "high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = optional(string)
  })
  description = "High availability configuration."
  default     = null
}

variable "maintenance_window" {
  type = object({
    day_of_week  = number
    start_hour   = number
    start_minute = number
  })
  description = "Maintenance window."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
