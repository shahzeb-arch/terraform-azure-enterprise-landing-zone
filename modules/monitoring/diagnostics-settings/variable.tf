variable "name" {
  type        = string
  description = "Diagnostic setting name."
}

variable "target_resource_id" {
  type        = string
  description = "Resource ID to attach diagnostics to."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace ID."
  default     = null
}

variable "storage_account_id" {
  type        = string
  description = "Optional storage account ID."
  default     = null
}

variable "eventhub_name" {
  type    = string
  default = null
}

variable "eventhub_authorization_rule_id" {
  type    = string
  default = null
}

variable "enabled_logs" {
  type = list(object({
    category       = optional(string)
    category_group = optional(string)
    retention_policy = optional(object({
      enabled = bool
      days    = number
    }))
  }))
  default = [{ category_group = "allLogs" }]
}

variable "metrics" {
  type = list(object({
    category = string
    enabled  = bool
    retention_policy = optional(object({
      enabled = bool
      days    = number
    }))
  }))
  default = [{ category = "AllMetrics", enabled = true }]
}
