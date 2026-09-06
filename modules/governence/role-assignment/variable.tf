variable "scope" {
  type        = string
  description = "Scope resource ID (subscription, RG, or resource)."
}

variable "principal_id" {
  type        = string
  description = "Object ID of the user, group, or service principal."
}

variable "role_definition_name" {
  type        = string
  description = "Built-in or custom role name (mutually exclusive with role_definition_id)."
  default     = null
}

variable "role_definition_id" {
  type        = string
  description = "Full role definition resource ID (mutually exclusive with role_definition_name)."
  default     = null
}

variable "principal_type" {
  type        = string
  description = "User, Group, ServicePrincipal, or ForeignGroup."
  default     = null
}

variable "description" {
  type        = string
  description = "Role assignment description."
  default     = "Managed by Terraform ELZ"
}

variable "skip_service_principal_aad_check" {
  type        = bool
  description = "Skip AAD propagation check for newly created service principals."
  default     = false
}
