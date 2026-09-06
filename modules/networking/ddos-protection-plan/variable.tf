variable "name" {
  type        = string
  description = "DDoS protection plan name."
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
