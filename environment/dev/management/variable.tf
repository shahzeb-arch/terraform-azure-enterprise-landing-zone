variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all management resources."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  description = "Resource groups for the management layer."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "automation_accounts" {
  description = "Automation account definitions."
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    sku_name           = optional(string, "Basic")
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }), { type = "SystemAssigned" })
    tags = optional(map(string), {})
  }))
  default = {}
}
