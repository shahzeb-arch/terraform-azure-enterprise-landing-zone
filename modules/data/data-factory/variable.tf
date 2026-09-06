variable "name" {
  type        = string
  description = "Data Factory name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "public_network_enabled" {
  type        = bool
  description = "Allow public network access."
  default     = false
}

variable "managed_virtual_network_enabled" {
  type        = bool
  description = "Enable managed virtual network for ADF."
  default     = true
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration."
  default     = null
}

variable "github_configuration" {
  type = object({
    account_name    = string
    branch_name     = string
    repository_name = string
    root_folder     = string
    git_url         = optional(string)
  })
  description = "GitHub CI/CD configuration."
  default     = null
}

variable "global_parameters" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Global parameters for pipelines."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
