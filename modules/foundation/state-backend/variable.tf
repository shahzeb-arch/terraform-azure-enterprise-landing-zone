variable "resource_group_name" {
  type        = string
  description = "Resource group for Terraform state backend."
  default     = "rg-terraform-state"
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique storage account name for state."
}

variable "container_name" {
  type        = string
  description = "Blob container name for tfstate files."
  default     = "tfstate"
}

variable "account_tier" {
  type        = string
  description = "Standard for production state backend."
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "GRS recommended for state durability."
  default     = "GRS"
}

variable "shared_access_key_enabled" {
  type        = bool
  description = "Disable when using Azure AD backend auth only."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Restrict to private access in production."
  default     = false
}

variable "blob_delete_retention_days" {
  type        = number
  description = "Soft delete retention for state blobs."
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
