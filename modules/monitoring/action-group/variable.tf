variable "name" {
  type        = string
  description = "Action group name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "short_name" {
  type        = string
  description = "Short name (max 12 chars)."
}

variable "enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "email_receivers" {
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}
