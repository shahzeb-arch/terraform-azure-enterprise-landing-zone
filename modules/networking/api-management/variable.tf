variable "name" {
  type        = string
  description = "API Management instance name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "publisher_name" {
  type        = string
  description = "Publisher name."
}

variable "publisher_email" {
  type        = string
  description = "Publisher email."
}

variable "sku_name" {
  type        = string
  description = "APIM SKU (Developer, Standard, Premium, etc.)."
  default     = "Developer_1"
}

variable "zones" {
  type        = list(string)
  description = "Availability zones."
  default     = []
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration."
  default     = null
}

variable "virtual_network_configuration" {
  type = object({
    subnet_id = string
  })
  description = "VNet integration for internal/external APIM."
  default     = null
}

variable "protocols" {
  type = object({
    enable_http2 = optional(bool, true)
  })
  description = "Protocol settings."
  default     = null
}

variable "security" {
  type = object({
    enable_backend_ssl30  = optional(bool, false)
    enable_backend_tls10  = optional(bool, false)
    enable_backend_tls11  = optional(bool, false)
    enable_frontend_ssl30 = optional(bool, false)
    enable_frontend_tls10 = optional(bool, false)
    enable_frontend_tls11 = optional(bool, false)
  })
  description = "TLS security settings."
  default     = null
}

variable "sign_in" {
  type = object({
    enabled = bool
  })
  description = "Developer portal sign-in settings."
  default     = null
}

variable "sign_up" {
  type = object({
    enabled = bool
    terms_of_service = optional(object({
      enabled          = bool
      consent_required = optional(bool, true)
      text             = optional(string)
    }))
  })
  description = "Developer portal sign-up settings."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
