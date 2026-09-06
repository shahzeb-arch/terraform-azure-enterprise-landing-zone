variable "name" {
  type        = string
  description = "Budget name."
}

variable "subscription_id" {
  type        = string
  description = "Target subscription ID."
}

variable "amount" {
  type        = number
  description = "Budget amount in billing currency."
}

variable "time_grain" {
  type        = string
  description = "Monthly, Quarterly, or Annually."
  default     = "Monthly"

  validation {
    condition     = contains(["Monthly", "Quarterly", "Annually"], var.time_grain)
    error_message = "time_grain must be Monthly, Quarterly, or Annually."
  }
}

variable "time_period" {
  type = object({
    start_date = string
    end_date   = string
  })
  description = "Budget time period (ISO 8601 dates)."
}

variable "notifications" {
  type = list(object({
    enabled        = optional(bool, true)
    threshold      = number
    operator       = string
    contact_emails = list(string)
    threshold_type = optional(string, "Actual")
  }))
  description = "Budget alert notifications."
  default     = []
}

variable "filter" {
  type = object({
    dimensions = optional(list(object({
      name     = string
      operator = string
      values   = list(string)
    })), [])
  })
  description = "Optional budget filter (e.g. by resource group)."
  default     = null
}
