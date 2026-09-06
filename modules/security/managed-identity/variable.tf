variable "name" {
  type        = string
  description = "User-assigned managed identity name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
