variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = map(string)
  }))
  description = "Resource group configuration"
}

variable "virtual_networks" {
  type = map(object({
    virtual_network_name = string
    resource_group_name  = string
    location             = string
    address_space        = list(string)
    tags                 = map(string)
  }))
}

variable "subnets" {
  type = map(object({
    subnet_name          = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
}

variable "network_security_groups" {
  description = "Network security group configurations."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    subnet_keys         = optional(list(string), [])
    security_rules = optional(list(object({
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
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "route_tables" {
  description = "Route table configurations."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    bgp_route_propagation_enabled = optional(bool, true)
    subnet_keys                   = optional(list(string), [])
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "nat_gateway" {
  description = "NAT Gateway configurations."
  type = map(object({
    nat_gateway_name        = string
    location                = string
    resource_group_name     = string
    sku_name                = string
    idle_timeout_in_minutes = optional(number, 10)
    zones                   = optional(list(string), ["1"])
    tags                    = optional(map(string), {})
  }))
  default = {}
}
