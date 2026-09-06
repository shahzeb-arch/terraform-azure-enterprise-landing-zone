variable "log_analytics_workspace_name" {
  type        = string
  description = "Central Log Analytics workspace name."
  default     = "log-dev-platform"
}

variable "log_analytics_resource_group_name" {
  type        = string
  description = "Resource group containing the Log Analytics workspace."
  default     = "rg-dev-monitoring"
}

variable "network_resource_group_name" {
  type        = string
  description = "Networking resource group name."
  default     = "rg-dev-network"
}

variable "hub_vnet_name" {
  type        = string
  description = "Hub virtual network name."
  default     = "vnet-1"
}

variable "enable_network_diagnostics" {
  type        = bool
  description = "Enable diagnostics for hub VNet."
  default     = true
}

variable "key_vault_lookups" {
  description = "Key Vault resources to attach diagnostics."
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "hub_vnet_enabled_logs" {
  description = "Enabled logs for hub VNet diagnostics."
  type = list(object({
    category       = optional(string)
    category_group = optional(string)
    retention_policy = optional(object({
      enabled = bool
      days    = number
    }))
  }))
  default = [
    {
      category_group = "allLogs"
    }
  ]
}

variable "key_vault_enabled_logs" {
  description = "Enabled logs for Key Vault diagnostics."
  type = list(object({
    category       = optional(string)
    category_group = optional(string)
    retention_policy = optional(object({
      enabled = bool
      days    = number
    }))
  }))
  default = [
    {
      category_group = "allLogs"
    }
  ]
}

variable "default_metrics" {
  description = "Default metrics for diagnostic settings."
  type = list(object({
    category = string
    enabled  = bool
    retention_policy = optional(object({
      enabled = bool
      days    = number
    }))
  }))
  default = [
    {
      category = "AllMetrics"
      enabled  = true
    }
  ]
}

variable "diagnostic_settings" {
  description = "Additional diagnostic setting definitions."
  type = map(object({
    name               = string
    target_resource_id = string
    enabled_logs = optional(list(object({
      category       = optional(string)
      category_group = optional(string)
      retention_policy = optional(object({
        enabled = bool
        days    = number
      }))
    })), [])
    metrics = optional(list(object({
      category = string
      enabled  = bool
      retention_policy = optional(object({
        enabled = bool
        days    = number
      }))
    })), [])
  }))
  default = {}
}
