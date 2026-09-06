variable "name" {
  type        = string
  description = "Function app name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "service_plan_id" {
  type        = string
  description = "App Service plan resource ID."
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name for function runtime state."
}

variable "storage_account_access_key" {
  type        = string
  description = "Storage account access key."
  sensitive   = true
}

variable "https_only" {
  type        = bool
  description = "Force HTTPS only."
  default     = true
}

variable "app_settings" {
  type        = map(string)
  description = "App settings key-value pairs."
  default     = {}
}

variable "site_config" {
  type = object({
    always_on                              = optional(bool, true)
    minimum_tls_version                    = optional(string, "1.2")
    ftps_state                             = optional(string, "Disabled")
    http2_enabled                          = optional(bool, true)
    vnet_route_all_enabled                 = optional(bool, false)
    application_insights_connection_string = optional(string)
    application_insights_key               = optional(string)
    application_stack = optional(object({
      dotnet_version              = optional(string)
      node_version                = optional(string)
      python_version              = optional(string)
      java_version                = optional(string)
      powershell_core_version     = optional(string)
      use_dotnet_isolated_runtime = optional(bool, false)
    }))
  })
  description = "Site configuration block."
  default     = {}
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration."
  default     = null
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Connection strings for the function app."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
