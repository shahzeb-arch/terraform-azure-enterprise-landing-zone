variable "name" {
  type        = string
  description = "Extension instance name."
}

variable "cluster_id" {
  type        = string
  description = "AKS cluster resource ID."
}

variable "extension_type" {
  type        = string
  description = "Extension type (for example Microsoft.AzureMonitor.AksControlPlane)."
}

variable "target_namespace" {
  type        = string
  description = "Target namespace for the extension."
  default     = null
}

variable "release_train" {
  type        = string
  description = "Release train for the extension."
  default     = "stable"
}

variable "release_namespace" {
  type        = string
  description = "Release namespace."
  default     = null
}

variable "configuration_settings" {
  type        = map(string)
  description = "Extension configuration settings."
  default     = {}
}

variable "configuration_protected_settings" {
  type        = map(string)
  description = "Protected configuration settings."
  default     = {}
  sensitive   = true
}

variable "plan" {
  type = object({
    name      = string
    product   = string
    publisher = string
    version   = optional(string)
  })
  description = "Marketplace plan for the extension."
  default     = null
}
