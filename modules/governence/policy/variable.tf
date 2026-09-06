variable "name" {
  type        = string
  description = "Policy definition name (unique within scope)."
}

variable "policy_type" {
  type        = string
  description = "Custom or Custom (subscription/MG scoped)."
  default     = "Custom"

  validation {
    condition     = contains(["Custom"], var.policy_type)
    error_message = "policy_type must be Custom for tenant-defined policies."
  }
}

variable "mode" {
  type        = string
  description = "Policy mode (Indexed, All, Microsoft.ContainerService.Data, etc.)."
  default     = "Indexed"
}

variable "display_name" {
  type        = string
  description = "Human-readable policy display name."
}

variable "description" {
  type        = string
  description = "Policy description."
  default     = "Managed by Terraform ELZ"
}

variable "policy_rule" {
  type        = string
  description = "JSON policy rule document."
}

variable "metadata" {
  type        = string
  description = "JSON metadata document."
  default     = null
}

variable "parameters" {
  type        = string
  description = "JSON parameters document."
  default     = null
}

variable "management_group_id" {
  type        = string
  description = "Optional management group ID for MG-scoped definitions."
  default     = null
}
