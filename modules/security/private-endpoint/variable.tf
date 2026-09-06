variable "name" {
  type        = string
  description = "Private endpoint name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the private endpoint (typically snet-pe)."
}

variable "private_service_connection" {
  type = object({
    name                           = string
    private_connection_resource_id = string
    subresource_names              = list(string)
    is_manual_connection           = optional(bool, false)
    request_message                = optional(string)
  })
  description = "Private Link connection to the target resource."
}

variable "private_dns_zone_group" {
  type = object({
    name                 = string
    private_dns_zone_ids = list(string)
  })
  description = "Optional DNS zone group for automatic private DNS integration."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
