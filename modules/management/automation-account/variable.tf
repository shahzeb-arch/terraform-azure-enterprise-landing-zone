variable "name" {
  type        = string
  description = "Automation account name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku_name" {
  type        = string
  description = "Basic or Free for dev; Basic recommended for production runbooks."
  default     = "Basic"
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration. SystemAssigned recommended for production."
  default = {
    type = "SystemAssigned"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
