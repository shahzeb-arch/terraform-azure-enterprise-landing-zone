variable "name" {
  type        = string
  description = "Bastion host name."
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
  description = "Basic or Standard."
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "sku must be Basic or Standard."
  }
}

variable "copy_paste_enabled" {
  type        = bool
  description = "Allow copy/paste through Bastion session."
  default     = false
}

variable "file_copy_enabled" {
  type        = bool
  description = "Allow file copy through Bastion (Standard SKU)."
  default     = false
}

variable "ip_connect_enabled" {
  type        = bool
  description = "Allow IP-based connections (Standard SKU)."
  default     = false
}

variable "shareable_link_enabled" {
  type        = bool
  description = "Allow shareable Bastion links (Standard SKU)."
  default     = false
}

variable "tunneling_enabled" {
  type        = bool
  description = "Enable native client tunneling (Standard SKU)."
  default     = false
}

variable "ip_configuration" {
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
  description = "Bastion IP configuration (AzureBastionSubnet + public IP)."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
