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
    subnet_name                       = string
    resource_group_name               = string
    virtual_network_name              = string
    address_prefixes                  = list(string)
    private_endpoint_network_policies = optional(string, "Enabled")
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

variable "public_ips" {
  description = "Public IP addresses (for NAT Gateway outbound)."
  type = map(object({
    public_ip_name      = string
    resource_group_name = string
    location            = string
    allocation_method   = optional(string, "Static")
    sku                 = optional(string, "Standard")
    sku_tier            = optional(string, "Regional")
    zones               = optional(list(string), ["1"])
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "nat_gateway_associations" {
  description = "Associate NAT Gateways with subnets and public IPs."
  type = map(object({
    subnet_keys    = list(string)
    public_ip_keys = optional(list(string), [])
  }))
  default = {}
}

variable "private_dns_zones" {
  description = "Private DNS zones for Private Link (privatelink.*)."
  type = map(object({
    private_dns_zone_name = string
    resource_group_name   = string
    soa_record = optional(object({
      email                   = string
      expire_time_in_seconds  = number
      minimum_ttl_in_seconds  = number
      refresh_time_in_seconds = number
      retry_time_in_seconds   = number
      ttl_in_seconds          = number
      soa_tags                = optional(map(string), {})
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "private_dns_vnet_links" {
  description = "Link private DNS zones to virtual networks."
  type = map(object({
    private_dns_zone_link_name = string
    resource_group_name        = string
    private_dns_zone_key       = string
    virtual_network_key        = string
    registration_enabled       = optional(bool, false)
    resolution_policy          = optional(string, "Default")
    tags                       = optional(map(string), {})
  }))
  default = {}
}
