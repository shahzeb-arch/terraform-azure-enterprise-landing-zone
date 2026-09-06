variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all monitoring resources."
  default = {
    Environment = "dev"
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

variable "data_collection_rules" {
  description = "Azure Monitor Data Collection Rules (AMA)."
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    description        = optional(string, "Platform DCR managed by Terraform ELZ")
    destinations = object({
      log_analytics = optional(list(object({
        name                  = string
        workspace_key         = optional(string)
        workspace_resource_id = optional(string)
      })), [])
      azure_monitor_metrics = optional(list(object({
        name = string
      })), [])
    })
    data_flows = optional(list(object({
      streams       = list(string)
      destinations  = list(string)
      transform_kql = optional(string)
      output_stream = optional(string)
    })), [])
    data_sources = optional(object({
      performance_counters = optional(list(object({
        name                          = string
        streams                       = list(string)
        sampling_frequency_in_seconds = number
        counter_specifiers            = list(string)
      })))
      syslogs = optional(list(object({
        name           = string
        facility_names = list(string)
        log_levels     = list(string)
        streams        = list(string)
      })))
      windows_event_logs = optional(list(object({
        name           = string
        streams        = list(string)
        x_path_queries = list(string)
      })))
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "metric_alerts" {
  description = "Platform metric alerts routed to action groups."
  type = map(object({
    name                        = string
    resource_group_key          = string
    scopes                      = optional(list(string))
    log_analytics_workspace_key = optional(string)
    description                 = optional(string, "ELZ metric alert")
    severity                    = optional(number, 2)
    frequency                   = optional(string, "PT5M")
    window_size                 = optional(string, "PT15M")
    enabled                     = optional(bool, true)
    auto_mitigate               = optional(bool, true)
    action_group_keys           = list(string)
    criteria = object({
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      threshold        = number
    })
    tags = optional(map(string), {})
  }))
  default = {}
}
