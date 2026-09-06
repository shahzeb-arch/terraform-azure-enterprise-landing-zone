variable "name" {
  description = "Name of the network interface."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the NIC will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the NIC will be created."
  type        = string
}

variable "accelerated_networking_enabled" {
  description = "Whether accelerated networking is enabled."
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "Custom DNS servers for the NIC."
  type        = list(string)
  default     = []
}

variable "internal_dns_name_label" {
  description = "Internal DNS name label for the NIC."
  type        = string
  default     = null
}

variable "ip_forwarding_enabled" {
  description = "Whether IP forwarding is enabled."
  type        = bool
  default     = false
}

variable "ip_configuration" {
  description = "Primary IP configuration."
  type = object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address            = optional(string)
    public_ip_address_id          = optional(string)
  })
}

variable "tags" {
  description = "Tags to apply to the NIC."
  type        = map(string)
  default     = {}
}
