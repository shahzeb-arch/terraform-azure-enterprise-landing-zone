variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all connectivity resources."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "network_resource_group_name" {
  type        = string
  description = "Existing networking resource group name."
  default     = "rg-dev-network"
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

variable "ddos_protection_plans" {
  description = "DDoS Network Protection plans for hub/spoke VNets."
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "vpn_gateways" {
  description = "Site-to-site / P2S VPN gateways (requires GatewaySubnet + public IP)."
  type = map(object({
    name          = string
    public_ip_key = string
    sku           = optional(string, "VpnGw1AZ")
    vpn_type      = optional(string, "RouteBased")
    active_active = optional(bool, false)
    enable_bgp    = optional(bool, false)
    ip_configuration = object({
      name = string
    })
    additional_ip_configurations = optional(list(object({
      name             = string
      public_ip_key    = string
    })), [])
    vpn_client_configuration = optional(object({
      address_space        = list(string)
      vpn_client_protocols = optional(list(string), ["OpenVPN"])
      vpn_auth_types       = optional(list(string), ["AAD"])
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "expressroute_gateways" {
  description = "ExpressRoute gateways (requires GatewaySubnet + public IP)."
  type = map(object({
    name          = string
    public_ip_key = string
    sku           = optional(string, "ErGw1AZ")
    ip_configuration = object({
      name = string
    })
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "application_gateways" {
  description = "WAF Application Gateways (requires dedicated /24 subnet)."
  type = map(object({
    name                       = string
    sku                        = optional(any)
    gateway_ip_configuration   = any
    frontend_ports             = optional(any)
    frontend_ip_configurations = any
    backend_address_pools      = any
    backend_http_settings      = any
    http_listeners             = any
    request_routing_rules      = any
    waf_configuration          = optional(any)
    tags                       = optional(map(string), {})
  }))
  default = {}
}

variable "frontdoors" {
  description = "Azure Front Door (Premium) profiles with optional WAF."
  type = map(object({
    name        = string
    sku_name    = optional(string, "Premium_AzureFrontDoor")
    identity    = optional(any)
    endpoints   = optional(map(object({
      name = string
      tags = optional(map(string), {})
    })), {})
    waf_policy = optional(any)
    tags       = optional(map(string), {})
  }))
  default = {}
}

variable "load_balancers" {
  description = "Internal or public Standard load balancers."
  type = map(object({
    name     = string
    sku      = optional(string, "Standard")
    sku_tier = optional(string, "Regional")
    frontend_ip_configuration = object({
      name                          = string
      subnet_id                     = optional(string)
      private_ip_address            = optional(string)
      private_ip_address_allocation = optional(string, "Dynamic")
      private_ip_address_version    = optional(string, "IPv4")
      public_ip_address_id          = optional(string)
      zones                         = optional(list(string))
    })
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "api_managements" {
  description = "API Management instance definitions."
  type = map(object({
    name                          = string
    publisher_name                = string
    publisher_email               = string
    sku_name                      = optional(string, "Developer_1")
    zones                         = optional(list(string), [])
    identity                      = optional(any)
    virtual_network_configuration = optional(any)
    protocols                     = optional(any)
    security                      = optional(any)
    sign_in                       = optional(any)
    sign_up                       = optional(any)
    tags                          = optional(map(string), {})
  }))
  default = {}
}

variable "virtual_wans" {
  description = "Virtual WAN definitions."
  type = map(object({
    name = string
    type = optional(string, "Standard")
    tags = optional(map(string), {})
  }))
  default = {}
}
