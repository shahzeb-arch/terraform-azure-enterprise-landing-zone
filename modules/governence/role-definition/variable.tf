variable "name" {
  type        = string
  description = "Custom role definition name."
}

variable "scope" {
  type        = string
  description = "Scope at which the role is defined (subscription or MG)."
}

variable "description" {
  type        = string
  description = "Role description."
  default     = null
}

variable "permissions" {
  type = object({
    actions          = optional(list(string), [])
    not_actions      = optional(list(string), [])
    data_actions     = optional(list(string), [])
    not_data_actions = optional(list(string), [])
  })
  description = "Permission sets for the custom role."
}

variable "assignable_scopes" {
  type        = list(string)
  description = "Scopes where this role can be assigned."
  default     = null
}
