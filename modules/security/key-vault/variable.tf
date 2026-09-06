variable "name" {
  type        = string
  description = "Key Vault name (3-24 alphanumeric characters)."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID."
}

variable "sku_name" {
  type        = string
  description = "Key Vault SKU (standard or premium)."
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be standard or premium."
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Soft-delete retention in days (7-90)."
  default     = 90
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Prevent permanent deletion during retention period."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public network access (disable for private-only)."
  default     = false
}

variable "rbac_authorization_enabled" {
  type        = bool
  description = "Use Azure RBAC for data-plane authorization."
  default     = true
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Allow Azure Disk Encryption to retrieve secrets."
  default     = true
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Allow VMs to retrieve certificates."
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow ARM to retrieve secrets."
  default     = false
}

variable "network_acls" {
  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  description = "Network ACLs when public access is restricted."
  default = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = []
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
