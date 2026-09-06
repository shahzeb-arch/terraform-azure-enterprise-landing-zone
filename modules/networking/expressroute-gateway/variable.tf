variable "name" {
  type        = string
  description = "ExpressRoute gateway name."
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
  description = "ErGw1AZ or higher for production HA."
  default     = "ErGw1AZ"
}

variable "ip_configuration" {
  type = object({
    name                          = string
    public_ip_address_id          = string
    private_ip_address_allocation = optional(string, "Dynamic")
    subnet_id                     = string
  })
  description = "IP configuration (GatewaySubnet)."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
