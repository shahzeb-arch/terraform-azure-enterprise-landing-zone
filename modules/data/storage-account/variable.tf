variable "name" {
  type        = string
  description = "Storage account name (3-24 lowercase alphanumeric)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "account_tier" {
  type        = string
  description = "Standard recommended for production."
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "GRS or GZRS for production durability."
  default     = "GRS"
}

variable "account_kind" {
  type        = string
  description = "StorageV2 for general purpose."
  default     = "StorageV2"
}

variable "access_tier" {
  type        = string
  description = "Hot or Cool."
  default     = "Hot"
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version."
  default     = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Disallow public blob access in production."
  default     = false
}

variable "shared_access_key_enabled" {
  type        = bool
  description = "Disable shared key access when using Azure AD auth only."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Disable public network access for private-only workloads."
  default     = false
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "Enable infrastructure encryption (double encryption)."
  default     = true
}

variable "blob_properties" {
  type = object({
    versioning_enabled              = optional(bool, true)
    change_feed_enabled             = optional(bool, true)
    last_access_time_enabled        = optional(bool, true)
    delete_retention_days           = optional(number, 30)
    container_delete_retention_days = optional(number, 30)
  })
  description = "Secure blob properties."
  default     = {}
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity for CMK or data plane RBAC."
  default     = null
}

variable "network_rules" {
  type = object({
    default_action             = string
    bypass                     = optional(list(string), ["AzureServices"])
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  description = "Network ACLs for the storage account."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
