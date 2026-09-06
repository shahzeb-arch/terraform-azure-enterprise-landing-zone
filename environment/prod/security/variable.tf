variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all security resources."
  default = {
    Environment = "Prod"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  description = "Resource groups for the security layer."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "key_vaults" {
  description = "Key Vault definitions."
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    tenant_id          = optional(string)
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "managed_identities" {
  description = "User-assigned managed identity definitions."
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "locks" {
  description = "Management lock definitions."
  type = map(object({
    name       = string
    scope      = string
    lock_level = string
    notes      = optional(string, "Managed by Terraform ELZ")
  }))
  default = {}
}

variable "defender_plans" {
  description = "Defender for Cloud pricing plans."
  type = object({
    resource_types = list(string)
    tier           = optional(string, "Standard")
    subplans       = optional(map(string), {})
  })
  default = null
}
