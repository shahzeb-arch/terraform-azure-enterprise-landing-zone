variable "name" {
  type        = string
  description = "Firewall Policy name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku" {
  type        = string
  description = "Standard or Premium."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.sku)
    error_message = "sku must be Standard or Premium."
  }
}

variable "dns_proxy_enabled" {
  type        = bool
  description = "Enable DNS proxy on the firewall policy."
  default     = true
}

variable "dns_servers" {
  type        = list(string)
  description = "Custom DNS servers for the firewall policy."
  default     = []
}

variable "threat_intelligence_mode" {
  type        = string
  description = "Alert, Deny, or Off."
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.threat_intelligence_mode)
    error_message = "threat_intelligence_mode must be Alert, Deny, or Off."
  }
}

variable "rule_collection_group" {
  type = object({
    name     = string
    priority = number
    application_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name              = string
        source_addresses  = list(string)
        destination_fqdns = list(string)
        protocol_type     = string
        protocol_port     = number
      }))
    })), [])
    network_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
      }))
    })), [])
    nat_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                = string
        protocols           = list(string)
        source_addresses    = list(string)
        destination_address = string
        destination_ports   = list(string)
        translated_address  = string
        translated_port     = string
      }))
    })), [])
  })
  description = "Optional rule collection group attached to the policy."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
