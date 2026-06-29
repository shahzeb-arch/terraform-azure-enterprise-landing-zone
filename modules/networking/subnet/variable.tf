variable "subnet_name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "virtual_network_name" {
  type = string
}
variable "address_prefixes" {
  type = list(string)
}
variable "service_endpoints" {
  type    = list(string)
  default = []
}
variable "delegation" {
  type = object({
    name            = string
    service_name    = string
    service_actions = list(string)
  })
  default = null
}
# variable "delegation_service_name" {
#   type = string
#   default = null
# }
# variable "delegation_service_actions" {
#   type = list(string)
#   default = []
# }
variable "default_outbound_access_enabled" {
  type    = bool
  default = true
}

variable "private_endpoint_network_policies" {
  type        = string
  description = "Private endpoint network policies (Enabled, Disabled, NetworkSecurityGroupEnabled, RouteTableEnabled)."
  default     = "Enabled"
}

variable "private_link_service_network_policies_enabled" {
  type        = bool
  description = "Whether network policies are enabled for Private Link service on the subnet."
  default     = true
}

variable "service_endpoint_policy_ids" {
  type    = list(string)
  default = []
}

variable "timeouts" {
  type = object({
    create = string
    delete = string
    read   = string
    update = string
  })
  default = null
}
