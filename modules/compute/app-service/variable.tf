variable "name" {
  type        = string
  description = "Web app name."
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

variable "https_only" {
  type        = bool
  description = "Force HTTPS only."
  default     = true
}

variable "client_affinity_enabled" {
  type        = bool
  description = "Enable client affinity (sticky sessions)."
  default     = false
}

variable "app_settings" {
  type        = map(string)
  description = "App settings key-value pairs."
  default     = {}
}

variable "site_config" {
  type = object({
    always_on              = optional(bool, true)
    minimum_tls_version    = optional(string, "1.2")
    ftps_state             = optional(string, "Disabled")
    http2_enabled          = optional(bool, true)
    vnet_route_all_enabled = optional(bool, false)
    health_check_path      = optional(string)
    application_stack = optional(object({
      dotnet_version = optional(string)
      java_version   = optional(string)
      node_version   = optional(string)
      python_version = optional(string)
      php_version    = optional(string)
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

variable "auth_settings_v2" {
  type = object({
    auth_enabled           = optional(bool, false)
    require_authentication = optional(bool, true)
    unauthenticated_action = optional(string, "RedirectToLoginPage")
    logins = optional(list(object({
      token_store_enabled = optional(bool, false)
    })), [])
  })
  description = "Authentication settings v2."
  default     = null
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Connection strings for the web app."
  default     = []
}

variable "sticky_settings" {
  type = object({
    app_setting_names       = optional(list(string), [])
    connection_string_names = optional(list(string), [])
  })
  description = "Slot sticky settings."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
