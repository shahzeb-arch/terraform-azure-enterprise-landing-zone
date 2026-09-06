variable "tenant_root_management_group_id" {
  type        = string
  description = "Tenant root management group ID: /providers/Microsoft.Management/managementGroups/<tenantId>."
}

variable "management_groups" {
  description = "Management group hierarchy definition."
  type = map(object({
    display_name               = string
    parent_management_group_id = optional(string)
  }))
  default = {}
}

variable "billing_scopes" {
  description = "MCA billing scopes keyed by logical name."
  type = map(object({
    billing_account_name = string
    billing_profile_name = string
    invoice_section_name = string
  }))
  default = {}
}

variable "subscriptions" {
  description = "Subscriptions to create and target management groups."
  type = map(object({
    subscription_name           = string
    alias                       = optional(string)
    billing_scope_key           = string
    target_management_group_key = string
    tags                        = optional(map(string), {})
  }))
  default = {}
}
