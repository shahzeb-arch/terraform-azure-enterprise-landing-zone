variable "name" {
  type        = string
  description = "VM backup policy name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "recovery_vault_name" {
  type        = string
  description = "Recovery Services Vault name."
}

variable "timezone" {
  type        = string
  description = "IANA timezone for backup schedule."
  default     = "UTC"
}

variable "backup" {
  type = object({
    frequency = string
    time      = string
    weekdays  = optional(list(string))
  })
  description = "Backup schedule (Daily or Weekly)."
}

variable "retention_daily" {
  type = object({
    count = number
  })
  description = "Daily retention in days."
  default     = null
}

variable "retention_weekly" {
  type = object({
    count    = number
    weekdays = optional(list(string), ["Sunday"])
  })
  description = "Weekly retention."
  default     = null
}

variable "retention_monthly" {
  type = object({
    count    = number
    weekdays = optional(list(string), ["Sunday"])
    weeks    = optional(list(string), ["First"])
  })
  description = "Monthly retention."
  default     = null
}

variable "retention_yearly" {
  type = object({
    count    = number
    weekdays = optional(list(string), ["Sunday"])
    weeks    = optional(list(string), ["First"])
    months   = optional(list(string), ["January"])
  })
  description = "Yearly retention."
  default     = null
}
