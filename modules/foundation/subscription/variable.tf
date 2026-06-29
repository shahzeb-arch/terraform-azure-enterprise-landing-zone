variable "subscription_name" {
  type        = string
  description = "Name of the subscription to create."
}

variable "billing_scope_id" {
  type        = string
  description = "Billing scope ID from MCA/EA billing account."
}

variable "alias" {
  type        = string
  description = "Optional alias for the subscription."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the subscription."
  default     = {}
}

variable "workload" {
  type        = string
  description = "Workload type for the subscription."
  default     = "Production"
}
