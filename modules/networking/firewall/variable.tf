variable "name" {
  type        = string
  description = "Azure Firewall name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku_name" {
  type        = string
  description = "AZFW_VNet or AZFW_Hub."
  default     = "AZFW_VNet"

  validation {
    condition     = contains(["AZFW_VNet", "AZFW_Hub"], var.sku_name)
    error_message = "sku_name must be AZFW_VNet or AZFW_Hub."
  }
}

variable "sku_tier" {
  type        = string
  description = "Standard or Premium."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be Standard or Premium."
  }
}

variable "firewall_policy_id" {
  type        = string
  description = "Firewall Policy resource ID (required for rule management)."
}

variable "zones" {
  type        = list(string)
  description = "Availability zones."
  default     = ["1", "2", "3"]
}

variable "ip_configuration" {
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
  description = "Firewall IP configuration (AzureFirewallSubnet + public IP)."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
