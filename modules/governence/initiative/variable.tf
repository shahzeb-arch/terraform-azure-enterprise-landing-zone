variable "name" {
  type        = string
  description = "Policy initiative (set) name."
}

variable "display_name" {
  type        = string
  description = "Display name."
}

variable "description" {
  type        = string
  description = "Initiative description."
  default     = null
}

variable "policy_type" {
  type        = string
  description = "Custom or BuiltIn."
  default     = "Custom"
}

variable "management_group_id" {
  type        = string
  description = "Management group scope for custom initiatives."
  default     = null
}

variable "policy_definition_references" {
  type = list(object({
    policy_definition_id       = string
    reference_id               = optional(string)
    parameter_values           = optional(string)
    policy_group_definition_id = optional(string)
    version                    = optional(string)
  }))
  description = "Policy definitions included in the initiative."
  default     = []
}

variable "policy_definition_groups" {
  type = list(object({
    name                            = string
    display_name                    = optional(string)
    description                     = optional(string)
    additional_metadata_resource_id = optional(string)
  }))
  description = "Policy definition groups for grouping references."
  default     = []
}

variable "parameters" {
  type        = string
  description = "JSON string of initiative parameters."
  default     = null
}

variable "metadata" {
  type        = string
  description = "JSON metadata."
  default     = null
}
