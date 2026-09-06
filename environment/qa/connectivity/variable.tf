variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all connectivity resources."
  default = {
    Environment = "Qa"
    ManagedBy   = "Terraform"
  }
}

variable "network_resource_group_name" {
  type        = string
  description = "Existing networking resource group name."
  default     = "rg-qa-network"
}

variable "hub_vnet_name" {
  type        = string
  description = "Existing hub virtual network name."
  default     = "vnet-1"
}

variable "location" {
  type        = string
  description = "Azure region for connectivity resources."
  default     = "East US"
}

variable "firewall_policies" {
  description = "Firewall policy definitions."
  type = map(object({
    name                     = string
    sku                      = optional(string, "Standard")
    dns_proxy_enabled        = optional(bool, true)
    threat_intelligence_mode = optional(string, "Alert")
    rule_collection_group    = optional(any)
    tags                     = optional(map(string), {})
  }))
  default = {}
}

variable "public_ips" {
  description = "Public IP definitions for firewall and bastion."
  type = map(object({
    public_ip_name    = string
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
    zones             = optional(list(string), ["1", "2", "3"])
    tags              = optional(map(string), {})
  }))
  default = {}
}

variable "firewalls" {
  description = "Azure Firewall definitions."
  type = map(object({
    name                = string
    sku_name            = optional(string, "AZFW_VNet")
    sku_tier            = optional(string, "Standard")
    firewall_policy_key = string
    public_ip_key       = string
    zones               = optional(list(string), ["1", "2", "3"])
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "bastion_hosts" {
  description = "Azure Bastion host definitions."
  type = map(object({
    name          = string
    sku           = optional(string, "Standard")
    public_ip_key = string
    tags          = optional(map(string), {})
  }))
  default = {}
}

variable "vnet_peerings" {
  description = "VNet peering definitions from the hub."
  type = map(object({
    name                      = string
    remote_virtual_network_id = string
    allow_forwarded_traffic   = optional(bool, true)
    allow_gateway_transit     = optional(bool, false)
    use_remote_gateways       = optional(bool, false)
  }))
  default = {}
}
