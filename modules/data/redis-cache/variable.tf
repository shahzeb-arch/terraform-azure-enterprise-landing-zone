variable "name" {
  type        = string
  description = "Redis cache name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "capacity" {
  type        = number
  description = "Cache size (0-6 for Basic/Standard, 1-5 for Premium)."
  default     = 1
}

variable "family" {
  type        = string
  description = "Cache family (C for Basic/Standard, P for Premium)."
  default     = "C"
}

variable "sku_name" {
  type        = string
  description = "Redis SKU (Basic, Standard, Premium)."
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_name)
    error_message = "sku_name must be Basic, Standard, or Premium."
  }
}

variable "minimum_tls_version" {
  type        = string
  description = "Minimum TLS version."
  default     = "1.2"
}

variable "non_ssl_port_enabled" {
  type        = bool
  description = "Enable non-SSL port (6379)."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public network access."
  default     = false
}

variable "redis_version" {
  type        = string
  description = "Redis version."
  default     = "6"
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration."
  default     = null
}

variable "redis_configuration" {
  type = object({
    maxmemory_policy                = optional(string, "allkeys-lru")
    maxmemory_reserved              = optional(number)
    maxmemory_delta                 = optional(number)
    maxfragmentationmemory_reserved = optional(number)
  })
  description = "Redis configuration settings."
  default     = null
}

variable "patch_schedules" {
  type = list(object({
    day_of_week    = string
    start_hour_utc = number
  }))
  description = "Maintenance patch schedules."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
