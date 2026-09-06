variable "name" {
  type        = string
  description = "VPN gateway name."
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
  description = "VpnGw1AZ or higher for production HA."
  default     = "VpnGw1AZ"
}

variable "vpn_type" {
  type        = string
  description = "RouteBased recommended for production."
  default     = "RouteBased"
}

variable "active_active" {
  type        = bool
  description = "Enable active-active mode."
  default     = false
}

variable "enable_bgp" {
  type        = bool
  description = "Enable BGP on the gateway."
  default     = false
}

variable "ip_configuration" {
  type = object({
    name                          = string
    public_ip_address_id          = string
    private_ip_address_allocation = optional(string, "Dynamic")
    subnet_id                     = string
  })
  description = "Primary IP configuration (GatewaySubnet)."
}

variable "additional_ip_configurations" {
  type = list(object({
    name                          = string
    public_ip_address_id          = string
    private_ip_address_allocation = optional(string, "Dynamic")
    subnet_id                     = string
  }))
  description = "Additional IP configurations for active-active."
  default     = []
}

variable "vpn_client_configuration" {
  type = object({
    address_space        = list(string)
    vpn_client_protocols = optional(list(string), ["OpenVPN"])
    vpn_auth_types       = optional(list(string), ["AAD"])
  })
  description = "Point-to-site VPN client configuration."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
