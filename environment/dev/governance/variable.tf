variable "common_tags" {
  type        = map(string)
  description = "Common tags (used in metadata where applicable)."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "tenant_root_management_group_id" {
  type        = string
  description = "Tenant root management group ID: /providers/Microsoft.Management/managementGroups/<tenantId>."
}

variable "management_groups" {
  description = "Microsoft ALZ management group hierarchy."
  type = map(object({
    display_name               = string
    parent_management_group_id = optional(string)
    parent_management_group_key = optional(string)
  }))
  default = {}
}

variable "billing_scopes" {
  description = "MCA billing scopes for new subscription vending (optional)."
  type = map(object({
    billing_account_name = string
    billing_profile_name = string
    invoice_section_name = string
  }))
  default = {}
}

variable "subscriptions" {
  description = "Create NEW subscriptions and associate to a management group."
  type = map(object({
    subscription_name           = string
    alias                       = optional(string)
    billing_scope_key           = string
    target_management_group_key = string
    tags                        = optional(map(string), {})
  }))
  default = {}
}

variable "subscription_placements" {
  description = "Associate EXISTING subscriptions to management groups (Microsoft ALZ platform model: one sub per platform MG)."
  type = map(object({
    subscription_id             = string
    target_management_group_key = string
  }))
  default = {}
}

variable "management_locks" {
  description = "CanNotDelete/ReadOnly locks at management group or subscription scope."
  type = map(object({
    name       = string
    scope      = string
    lock_level = string
    notes      = optional(string, "Managed by Terraform ELZ")
  }))
  default = {}
}

variable "subscription_id" {
  type        = string
  description = "Fallback subscription ID for governance resources when scope not specified."
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
    management_group_key = optional(string)
    subscription_key     = optional(string)
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
    name             = string
    subscription_id  = optional(string)
    subscription_key = optional(string)
    amount           = number
    time_grain       = optional(string, "Monthly")
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

variable "policies" {
  description = "Custom policy definitions (CAF-aligned)."
  type = map(object({
    name                    = string
    policy_type             = optional(string, "Custom")
    mode                    = optional(string, "Indexed")
    display_name            = string
    description             = optional(string, "Managed by Terraform ELZ")
    policy_rule             = string
    metadata                = optional(string)
    parameters              = optional(string)
    management_group_id     = optional(string)
    management_group_key    = optional(string)
  }))
  default = {}
}

variable "initiatives" {
  description = "Custom policy initiatives (policy sets)."
  type = map(object({
    name                         = string
    display_name                 = string
    description                  = optional(string)
    policy_type                  = optional(string, "Custom")
    management_group_id          = optional(string)
    management_group_key         = optional(string)
    policy_definition_references = optional(list(object({
      policy_definition_id = string
      reference_id         = optional(string)
      parameter_values     = optional(string)
      version              = optional(string)
    })), [])
    policy_definition_groups = optional(list(object({
      name         = string
      display_name = optional(string)
      description  = optional(string)
    })), [])
    parameters = optional(string)
    metadata   = optional(string)
  }))
  default = {}
}

variable "role_definitions" {
  description = "Custom RBAC role definitions."
  type = map(object({
    name        = string
    scope       = string
    description = optional(string)
    permissions = object({
      actions          = optional(list(string), [])
      not_actions      = optional(list(string), [])
      data_actions     = optional(list(string), [])
      not_data_actions = optional(list(string), [])
    })
    assignable_scopes = optional(list(string))
  }))
  default = {}
}
