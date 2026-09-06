variable "name" {
  type        = string
  description = "SQL server name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "server_version" {
  type        = string
  description = "SQL Server version."
  default     = "12.0"
}

variable "administrator_login" {
  type        = string
  description = "SQL admin login."
}

variable "administrator_login_password" {
  type        = string
  description = "SQL admin password."
  sensitive   = true
}

variable "minimum_tls_version" {
  type        = string
  description = "Minimum TLS version."
  default     = "1.2"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public network access."
  default     = false
}

variable "outbound_network_restriction_enabled" {
  type        = bool
  description = "Restrict outbound network access."
  default     = true
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration."
  default     = null
}

variable "azuread_administrator" {
  type = object({
    login_username              = string
    object_id                   = string
    azuread_authentication_only = optional(bool, false)
  })
  description = "Azure AD administrator for SQL server."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
