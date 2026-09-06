variable "name" {
  type        = string
  description = "Front Door profile name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku_name" {
  type        = string
  description = "Standard_AzureFrontDoor or Premium_AzureFrontDoor for WAF."
  default     = "Premium_AzureFrontDoor"
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity for Key Vault certificate integration."
  default     = null
}

variable "endpoints" {
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))
  description = "Front Door endpoints."
  default     = {}
}

variable "waf_policy" {
  type = object({
    name                              = string
    sku_name                          = optional(string, "Premium_AzureFrontDoor")
    enabled                           = optional(bool, true)
    mode                              = optional(string, "Prevention")
    redirect_url                      = optional(string)
    custom_block_response_status_code = optional(number)
    custom_block_response_body        = optional(string)
    managed_rules = optional(list(object({
      type    = string
      version = string
      action  = optional(string, "Block")
      })), [{
      type    = "Microsoft_DefaultRuleSet"
      version = "2.1"
      action  = "Block"
    }])
  })
  description = "Optional WAF policy for Front Door."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
