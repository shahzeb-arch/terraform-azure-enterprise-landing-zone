variable "name" {
  type        = string
  description = "Virtual WAN name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "type" {
  type        = string
  description = "Virtual WAN type (Basic or Standard)."
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.type)
    error_message = "type must be Basic or Standard."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
