variable "name" {
  type        = string
  description = "App Service plan name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "os_type" {
  type        = string
  description = "Operating system type (Linux or Windows)."
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "os_type must be Linux or Windows."
  }
}

variable "sku_name" {
  type        = string
  description = "App Service plan SKU (e.g. P1v3, EP1, Y1)."
  default     = "P1v3"
}

variable "worker_count" {
  type        = number
  description = "Number of workers (scale-out instances)."
  default     = 1
}

variable "zone_balancing_enabled" {
  type        = bool
  description = "Enable zone balancing for Premium SKUs."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
