variable "private_dns_zone_link_name" {
    type        = string
    description = "The name of the Private DNS Zone Virtual Network Link."
}

variable "resource_group_name" {
    type        = string
    description = "The name of the Resource Group."
}

variable "private_dns_zone_name" {
    type        = string
    description = "The name of the Private DNS Zone."
}

variable "virtual_network_id" {
    type        = string
    description = "The ID of the Virtual Network."
}

variable "registration_enabled" {
    type        = bool
    description = "Whether registration is enabled for the Private DNS Zone Virtual Network Link."

    default     = false
}

variable "resolution_policy" {
    type        = string
    description = "The resolution policy for the Private DNS Zone Virtual Network Link."

    default     = "Default"
}

variable "tags" {
    type = map(string)
    description = "A map of tags to assign to the Private DNS Zone Virtual Network Link."

    default = {}
}