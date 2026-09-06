variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all monitoring resources."
  default = {
    Environment = "Qa"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  description = "Resource groups for the monitoring layer."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "log_analytics_workspaces" {
  description = "Log Analytics workspace definitions."
  type = map(object({
    name                       = string
    location                   = string
    resource_group_key         = string
    sku                        = optional(string, "PerGB2018")
    retention_in_days          = optional(number, 90)
    daily_quota_gb             = optional(number, -1)
    internet_ingestion_enabled = optional(bool, false)
    internet_query_enabled     = optional(bool, false)
    tags                       = optional(map(string), {})
  }))
  default = {}
}

variable "action_groups" {
  description = "Monitor action group definitions."
  type = map(object({
    name               = string
    resource_group_key = string
    short_name         = string
    enabled            = optional(bool, true)
    email_receivers = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}
