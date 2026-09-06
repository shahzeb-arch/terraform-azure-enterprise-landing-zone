variable "nat_gateway_name" {
  type        = string
  description = "The name of the NAT Gateway."
}

variable "location" {
  type        = string
  description = "Azure region where the NAT Gateway will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name where the NAT Gateway will be created."
}

variable "sku_name" {
  type        = string
  description = "SKU of the NAT Gateway. Only Standard is supported."
  default     = "Standard"
}

variable "idle_timeout_in_minutes" {
  type        = number
  description = "Idle timeout in minutes for the NAT Gateway (4-120)."
  default     = 10
}

variable "zones" {
  type        = list(string)
  description = "Availability zones for the NAT Gateway."
  default     = ["1"]
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the NAT Gateway."
  default     = {}
}
