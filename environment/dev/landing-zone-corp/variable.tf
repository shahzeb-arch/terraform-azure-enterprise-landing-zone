variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to landing zone resources."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "hub_resource_group_name" {
  type        = string
  description = "Hub networking resource group."
  default     = "rg-dev-network"
}

variable "hub_vnet_name" {
  type        = string
  description = "Hub virtual network name."
  default     = "vnet-1"
}

variable "rgs" {
  description = "Landing zone resource groups."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "virtual_networks" {
  description = "Spoke virtual networks."
  type = map(object({
    virtual_network_name = string
    resource_group_key   = string
    location             = string
    address_space        = list(string)
    tags                 = optional(map(string), {})
  }))
}

variable "subnets" {
  description = "Spoke subnets."
  type = map(object({
    subnet_name                       = string
    resource_group_key                = string
    virtual_network_name              = string
    address_prefixes                  = list(string)
    private_endpoint_network_policies = optional(string, "Enabled")
  }))
  default = {}
}

variable "vnet_peerings" {
  description = "Bidirectional peering between hub and spoke."
  type = map(object({
    resource_group_key      = string
    spoke_vnet_key          = string
    hub_peering_name        = string
    spoke_peering_name      = string
    allow_forwarded_traffic = optional(bool, true)
    allow_gateway_transit   = optional(bool, true)
    use_remote_gateways     = optional(bool, false)
  }))
  default = {}
}
