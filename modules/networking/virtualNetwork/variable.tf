variable "virtual_network_name" {
  type        = string
  description = "Virtual network name."
}

variable "location" {
  type        = string
  description = "Azure region."
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name where VNet will be created."

}

# variable "parent_id" {
#   type        = string
#   description = "Resource group ID where VNet will be created."

#   validation {
#     condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+$", var.parent_id))
#     error_message = "parent_id must be a valid resource group ID."
#   }
# }

variable "address_space" {
  type        = list(string)
  description = "Address spaces for the VNet."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply."
}

variable "ddos_protection_plan" {
  type = object({
    id     = string
    enable = bool
  })
  default     = null
  description = "Optional DDoS protection plan config."
}

variable "encryption" {
  type = object({
    enforcement = string
  })
  default     = null
  description = "Optional encryption settings."

  validation {
    condition     = var.encryption == null || contains(["AllowUnencrypted", "DropUnencrypted"], var.encryption.enforcement)
    error_message = "enforcement must be AllowUnencrypted or DropUnencrypted."
  }
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "Optional DNS servers for the VNet."

}
variable "edge_zone" {
  type        = string
  default     = null
  description = "Optional edge zone for the VNet."
}
variable "flow_timeout_in_minutes" {
  type        = number
  default     = null
  description = "Optional flow timeout in minutes for the VNet."

}