variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all security resources."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  description = "Resource groups for the security layer."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "key_vaults" {
  description = "Key Vault definitions."
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    tenant_id          = optional(string)
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "managed_identities" {
  description = "User-assigned managed identity definitions."
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "locks" {
  description = "Management lock definitions."
  type = map(object({
    name       = string
    scope      = string
    lock_level = string
    notes      = optional(string, "Managed by Terraform ELZ")
  }))
  default = {}
}

variable "defender_plans" {
  description = "Defender for Cloud pricing plans."
  type = object({
    resource_types = list(string)
    tier           = optional(string, "Standard")
    subplans       = optional(map(string), {})
  })
  default = null
}

variable "subnet_lookups" {
  description = "Subnets from the networking layer for private endpoint placement."
  type = map(object({
    subnet_name          = string
    virtual_network_name = string
    resource_group_name  = string
  }))
  default = {}
}

variable "disk_encryption_sets" {
  description = "Disk encryption sets for CMK (requires Key Vault key URI)."
  type = map(object({
    name                      = string
    location                  = string
    resource_group_key        = string
    key_vault_key_id          = string
    encryption_type           = optional(string, "EncryptionAtRestWithCustomerKey")
    auto_key_rotation_enabled = optional(bool, true)
    federated_client_id       = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }), { type = "SystemAssigned" })
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "key_vault_keys" {
  description = "Key Vault keys with optional rotation policy."
  type = map(object({
    name           = string
    key_vault_key  = string
    key_type       = optional(string, "RSA")
    key_size       = optional(number, 2048)
    key_opts       = optional(list(string), ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"])
    expiration_date = optional(string)
    rotation_policy = optional(object({
      expire_after         = optional(string, "P90D")
      notify_before_expiry = optional(string, "P29D")
      automatic = optional(object({
        time_before_expiry = string
      }))
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# variable "private_endpoints" {
#   description = "Private Link endpoints for platform services (Key Vault, Storage, etc.)."
#   type = map(object({
#     name               = string
#     location           = string
#     resource_group_key = string
#     subnet_key         = string
#     private_service_connection = object({
#       name                           = string
#       private_connection_resource_id = string
#       subresource_names              = list(string)
#       is_manual_connection           = optional(bool, false)
#       request_message                = optional(string)
#     })
#     private_dns_zone_group = optional(object({
#       name                 = string
#       private_dns_zone_ids = list(string)
#     }))
#     tags = optional(map(string), {})
#   }))
#   default = {}
# }
