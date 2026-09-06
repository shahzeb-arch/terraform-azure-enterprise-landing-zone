variable "org" {
  type        = string
  description = "Organization short name."
}

variable "env" {
  type        = string
  description = "Environment (dev, staging, prod)."

  validation {
    condition     = contains(["dev", "staging", "prod", "test", "qa"], var.env)
    error_message = "env must be dev, staging, prod, test, or qa."
  }
}

variable "region" {
  type        = string
  description = "Azure region short code (e.g. eus, weu)."
}

variable "workload" {
  type        = string
  description = "Workload name (e.g. network, aks, security)."
  default     = null
}

variable "suffix" {
  type        = string
  description = "Optional extra suffix for disambiguation."
  default     = null
}
