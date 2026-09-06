variable "resource_types" {
  type        = list(string)
  description = "Defender plan resource types to enable (e.g. VirtualMachines, SqlServers, StorageAccounts)."
}

variable "tier" {
  type        = string
  description = "Pricing tier (Free or Standard)."
  default     = "Standard"

  validation {
    condition     = contains(["Free", "Standard"], var.tier)
    error_message = "tier must be Free or Standard."
  }
}

variable "subplans" {
  type        = map(string)
  description = "Optional subplan per resource type (e.g. P1 for AppServices)."
  default     = {}
}
