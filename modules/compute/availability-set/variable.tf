variable "name" {
  type        = string
  description = "Availability set name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "platform_fault_domain_count" {
  type        = number
  description = "Fault domain count (2-3)."
  default     = 2
}

variable "platform_update_domain_count" {
  type        = number
  description = "Update domain count."
  default     = 5
}

variable "managed" {
  type        = bool
  description = "Use managed platform placement."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
