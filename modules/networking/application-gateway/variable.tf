variable "name" {
  type        = string
  description = "Application Gateway name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "enable_http2" {
  type        = bool
  description = "Enable HTTP/2."
  default     = true
}

variable "sku" {
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
  description = "Use WAF_v2 tier for production web workloads."
  default = {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }
}

variable "gateway_ip_configuration" {
  type = object({
    name      = string
    subnet_id = string
  })
  description = "Dedicated Application Gateway subnet (/24 recommended)."
}

variable "frontend_ports" {
  type = list(object({
    name = string
    port = number
  }))
  description = "Frontend ports."
  default = [
    { name = "http-port", port = 80 },
    { name = "https-port", port = 443 }
  ]
}

variable "frontend_ip_configurations" {
  type = list(object({
    name                          = string
    public_ip_address_id          = optional(string)
    private_ip_address            = optional(string)
    private_ip_address_allocation = optional(string)
    subnet_id                     = optional(string)
  }))
  description = "Frontend IP configurations."
}

variable "backend_address_pools" {
  type = list(object({
    name         = string
    fqdns        = optional(list(string), [])
    ip_addresses = optional(list(string), [])
  }))
  description = "Backend address pools."
  default     = []
}

variable "backend_http_settings" {
  type = list(object({
    name                                = string
    cookie_based_affinity               = optional(string, "Disabled")
    port                                = number
    protocol                            = string
    request_timeout                     = optional(number, 30)
    pick_host_name_from_backend_address = optional(bool, false)
    host_name                           = optional(string)
  }))
  description = "Backend HTTP settings."
  default     = []
}

variable "http_listeners" {
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    ssl_certificate_name           = optional(string)
  }))
  description = "HTTP listeners."
  default     = []
}

variable "request_routing_rules" {
  type = list(object({
    name                       = string
    rule_type                  = string
    priority                   = number
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
  }))
  description = "Request routing rules."
  default     = []
}

variable "ssl_certificates" {
  type = list(object({
    name     = string
    data     = string
    password = optional(string)
  }))
  description = "SSL certificates (prefer Key Vault integration in production)."
  default     = []
  sensitive   = true
}

variable "waf_configuration" {
  type = object({
    enabled          = bool
    firewall_mode    = optional(string, "Prevention")
    rule_set_type    = optional(string, "OWASP")
    rule_set_version = optional(string, "3.2")
  })
  description = "WAF configuration for WAF_v2 SKU."
  default = {
    enabled       = true
    firewall_mode = "Prevention"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
