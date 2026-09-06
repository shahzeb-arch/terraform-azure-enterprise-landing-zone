variable "name" {
  type        = string
  description = "Alert rule name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "scopes" {
  type        = list(string)
  description = "Monitored resource IDs."
}

variable "description" {
  type    = string
  default = "ELZ metric alert"
}

variable "severity" {
  type    = number
  default = 2
}

variable "frequency" {
  type    = string
  default = "PT5M"
}

variable "window_size" {
  type    = string
  default = "PT15M"
}

variable "enabled" {
  type    = bool
  default = true
}

variable "auto_mitigate" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "criteria" {
  type = object({
    metric_namespace = string
    metric_name      = string
    aggregation      = string
    operator         = string
    threshold        = number
  })
}

variable "action_group_ids" {
  type    = list(string)
  default = []
}
