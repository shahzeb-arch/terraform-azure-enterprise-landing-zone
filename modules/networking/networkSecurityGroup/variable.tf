variable "name" {
  description = "Name of the network security group."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the NSG will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the NSG will be created."
  type        = string
}

variable "security_rules" {
  description = "Inline security rules for the NSG."
  type = list(object({
    name                                       = string
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
    description                                = optional(string)
  }))
  default = []
}

variable "subnet_ids" {
  description = "Subnet IDs to associate with the NSG."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the NSG."
  type        = map(string)
  default     = {}
}
