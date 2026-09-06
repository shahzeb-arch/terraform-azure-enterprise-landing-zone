variable "name" {
  type        = string
  description = "Databricks workspace name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku" {
  type        = string
  description = "Databricks SKU (standard or premium)."
  default     = "premium"

  validation {
    condition     = contains(["standard", "premium"], var.sku)
    error_message = "sku must be standard or premium."
  }
}

variable "managed_resource_group_name" {
  type        = string
  description = "Managed resource group name for Databricks."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public network access."
  default     = false
}

variable "network_security_group_rules_required" {
  type        = string
  description = "NSG rules requirement (AllRules, NoAzureDatabricksRules, NoAzureServiceRules)."
  default     = "NoAzureDatabricksRules"
}

variable "custom_parameters" {
  type = object({
    no_public_ip                                         = optional(bool, true)
    virtual_network_id                                   = optional(string)
    public_subnet_name                                   = optional(string)
    private_subnet_name                                  = optional(string)
    public_subnet_network_security_group_association_id  = optional(string)
    private_subnet_network_security_group_association_id = optional(string)
    storage_account_name                                 = optional(string)
    storage_account_sku_name                               = optional(string, "Standard_GRS")
  })
  description = "VNet injection custom parameters."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
