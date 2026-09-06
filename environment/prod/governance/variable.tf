variable "common_tags" {
  type        = map(string)
  description = "Common tags (used in metadata where applicable)."
  default = {
    Environment = "Prod"
    ManagedBy   = "Terraform"
  }
}

variable "subscription_id" {
  type        = string
  description = "Target subscription ID for governance resources."
  default     = null
}

variable "policy_assignments" {
  description = "Policy assignment definitions."
  type = map(object({
    name                 = string
    display_name         = string
    policy_definition_id = string
    scope_type           = string
    scope_id             = optional(string)
    description          = optional(string, "Managed by Terraform ELZ")
    location             = optional(string)
    identity_type        = optional(string, "None")
    parameters           = optional(string)
    enforce              = optional(bool, true)
  }))
  default = {}
}

variable "role_assignments" {
  description = "RBAC role assignment definitions."
  type = map(object({
    scope                            = string
    principal_id                     = string
    role_definition_name             = optional(string)
    role_definition_id               = optional(string)
    principal_type                   = optional(string)
    description                      = optional(string, "Managed by Terraform ELZ")
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}
}

variable "budgets" {
  description = "Subscription budget definitions."
  type = map(object({
    name            = string
    subscription_id = optional(string)
    amount          = number
    time_grain      = optional(string, "Monthly")
    time_period = object({
      start_date = string
      end_date   = string
    })
    notifications = optional(list(object({
      enabled        = optional(bool, true)
      threshold      = number
      operator       = string
      contact_emails = list(string)
      threshold_type = optional(string, "Actual")
    })), [])
  }))
  default = {}
}
