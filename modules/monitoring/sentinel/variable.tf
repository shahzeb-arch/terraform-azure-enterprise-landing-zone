variable "workspace_id" {
  type        = string
  description = "Log Analytics workspace resource ID for Sentinel onboarding."
}

variable "enable_aad_data_connector" {
  type        = bool
  description = "Enable Azure AD data connector for Sentinel."
  default     = true
}

variable "aad_data_connector_name" {
  type        = string
  description = "Name for the Azure AD Sentinel data connector."
  default     = "AzureActiveDirectory"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID for the AAD data connector."
  default     = null
}
