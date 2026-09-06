variable "name" {
  type        = string
  description = "Unique management group name (ID)."
}

variable "display_name" {
  type        = string
  description = "Display name of the management group."
}

variable "parent_management_group_id" {
  type        = string
  description = "Parent management group resource ID."
  default     = null
}