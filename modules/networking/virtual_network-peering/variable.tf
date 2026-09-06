variable "name" {
  type        = string
  description = "VNet peering name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group of the local VNet."
}

variable "virtual_network_name" {
  type        = string
  description = "Local VNet name."
}

variable "remote_virtual_network_id" {
  type        = string
  description = "Remote VNet resource ID."
}

variable "allow_virtual_network_access" {
  type        = bool
  description = "Allow traffic between peered VNets."
  default     = true
}

variable "allow_forwarded_traffic" {
  type        = bool
  description = "Allow forwarded traffic from remote VNet (required for hub-spoke via firewall)."
  default     = true
}

variable "allow_gateway_transit" {
  type        = bool
  description = "Allow remote VNet to use local gateway."
  default     = false
}

variable "use_remote_gateways" {
  type        = bool
  description = "Use remote VNet gateway (mutually exclusive with allow_gateway_transit on same side)."
  default     = false
}
