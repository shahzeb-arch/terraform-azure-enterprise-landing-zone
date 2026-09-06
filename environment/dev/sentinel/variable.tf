variable "log_analytics_workspaces" {
  description = "Existing Log Analytics workspaces to reference."
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}

variable "sentinel_onboarding" {
  description = "Sentinel onboarding configurations."
  type = map(object({
    workspace_lookup_key      = string
    enable_aad_data_connector = optional(bool, true)
    aad_data_connector_name   = optional(string, "AzureActiveDirectory")
    tenant_id                 = optional(string)
  }))
  default = {}
}
