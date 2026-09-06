variable "name" {
  type        = string
  description = "Policy assignment name."
}

variable "display_name" {
  type        = string
  description = "Human-readable assignment display name."
}

variable "policy_definition_id" {
  type        = string
  description = "Policy or initiative definition resource ID."
}

variable "scope_type" {
  type        = string
  description = "subscription, resource_group, or management_group."

  validation {
    condition     = contains(["subscription", "resource_group", "management_group"], var.scope_type)
    error_message = "scope_type must be subscription, resource_group, or management_group."
  }
}

variable "scope_id" {
  type        = string
  description = "Subscription ID or resource group ID depending on scope_type."
}

variable "description" {
  type        = string
  description = "Assignment description."
  default     = "Managed by Terraform ELZ"
}

variable "location" {
  type        = string
  description = "Azure region (required for Managed Identity deploy-if-not-exists policies)."
  default     = null
}

variable "identity_type" {
  type        = string
  description = "Managed identity type (None or SystemAssigned)."
  default     = "None"
}

variable "parameters" {
  type        = string
  description = "JSON parameters for the policy assignment."
  default     = null
}

variable "metadata" {
  type        = string
  description = "JSON metadata for the policy assignment."
  default     = null
}

variable "enforce" {
  type        = bool
  description = "Whether to enforce the policy (false = audit only)."
  default     = true
}
