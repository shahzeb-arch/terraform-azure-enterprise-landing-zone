variable "name" {
  type        = string
  description = "Name of the management lock."
}

variable "scope" {
  type        = string
  description = "Scope resource ID (subscription, RG, or resource)."
}

variable "lock_level" {
  type        = string
  description = "CanNotDelete or ReadOnly."

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "lock_level must be CanNotDelete or ReadOnly."
  }
}

variable "notes" {
  type        = string
  description = "Notes describing the lock purpose."
  default     = "Managed by Terraform ELZ"
}
