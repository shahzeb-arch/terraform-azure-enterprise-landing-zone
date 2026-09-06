variable "name" {
  type        = string
  description = "Data collection rule name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "description" {
  type        = string
  description = "DCR description."
  default     = null
}

variable "destinations" {
  type = object({
    log_analytics = optional(list(object({
      name                  = string
      workspace_resource_id = string
    })), [])
    azure_monitor_metrics = optional(list(object({
      name = string
    })), [])
  })
  description = "DCR destinations."
}

variable "data_flows" {
  type = list(object({
    streams       = list(string)
    destinations  = list(string)
    transform_kql = optional(string)
    output_stream = optional(string)
  }))
  description = "Data flows mapping sources to destinations."
  default     = []
}

variable "data_sources" {
  type = object({
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
  })
  description = "Data sources collected by the DCR."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
