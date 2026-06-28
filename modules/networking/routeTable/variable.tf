variable "name" {
  description = "Name of the route table."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the route table will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the route table will be created."
  type        = string
}

variable "bgp_route_propagation_enabled" {
  description = "Whether BGP route propagation is enabled."
  type        = bool
  default     = true
}

variable "routes" {
  description = "Routes to create inside the route table."
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = []
}

variable "subnet_ids" {
  description = "Subnet IDs to associate with the route table."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the route table."
  type        = map(string)
  default     = {}
}
