variable "name" {
  type        = string
  description = "Database name."
}

variable "server_id" {
  type        = string
  description = "SQL server resource ID."
}

variable "collation" {
  type        = string
  description = "Database collation."
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "max_size_gb" {
  type        = number
  description = "Maximum database size in GB."
  default     = 32
}

variable "sku_name" {
  type        = string
  description = "Database SKU (e.g. S0, GP_Gen5_2)."
  default     = "S0"
}

variable "zone_redundant" {
  type        = bool
  description = "Enable zone redundancy."
  default     = false
}

variable "long_term_retention_policy" {
  type = object({
    weekly_retention  = optional(string)
    monthly_retention = optional(string)
    yearly_retention  = optional(string)
    week_of_year      = optional(number)
  })
  description = "Long-term backup retention policy."
  default     = null
}

variable "short_term_retention_policy" {
  type = object({
    retention_days           = optional(number, 7)
    backup_interval_in_hours = optional(number, 12)
  })
  description = "Short-term backup retention policy."
  default     = null
}

variable "threat_detection_policy" {
  type = object({
    state                      = optional(string, "Enabled")
    email_account_admins       = optional(string, "Enabled")
    email_addresses            = optional(list(string), [])
    retention_days             = optional(number, 90)
    storage_account_access_key = optional(string)
    storage_endpoint           = optional(string)
  })
  description = "Advanced threat detection policy."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
