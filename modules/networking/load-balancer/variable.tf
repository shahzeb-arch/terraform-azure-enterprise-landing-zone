variable "name" {
  type        = string
  description = "Load balancer name."
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
  description = "Basic or Standard."
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "sku must be Basic or Standard."
  }
}

variable "sku_tier" {
  type        = string
  description = "Regional or Global."
  default     = "Regional"
}

variable "frontend_ip_configuration" {
  type = object({
    name                          = string
    subnet_id                     = optional(string)
    private_ip_address            = optional(string)
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address_version    = optional(string, "IPv4")
    public_ip_address_id          = optional(string)
    zones                         = optional(list(string))
  })
  description = "Frontend IP configuration for the load balancer."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
