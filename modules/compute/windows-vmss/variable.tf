variable "name" {
  type        = string
  description = "Windows VMSS name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "sku" {
  type        = string
  description = "VM size SKU."
}

variable "instances" {
  type        = number
  description = "Instance count."
  default     = 2
}

variable "admin_username" {
  type        = string
  description = "Local admin username."
}

variable "admin_password" {
  type        = string
  description = "Local admin password."
  sensitive   = true
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for NIC IP configuration."
}

variable "overprovision" {
  type        = bool
  description = "Overprovision instances."
  default     = false
}

variable "upgrade_mode" {
  type        = string
  description = "Manual or Automatic (Rolling recommended)."
  default     = "Rolling"
}

variable "single_placement_group" {
  type        = bool
  description = "Single placement group."
  default     = true
}

variable "encryption_at_host_enabled" {
  type        = bool
  description = "Enable encryption at host."
  default     = true
}

variable "secure_boot_enabled" {
  type        = bool
  description = "Enable secure boot."
  default     = true
}

variable "vtpm_enabled" {
  type        = bool
  description = "Enable vTPM."
  default     = true
}

variable "zones" {
  type        = list(string)
  description = "Availability zones."
  default     = ["1", "2", "3"]
}

variable "os_disk" {
  type = object({
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "Premium_LRS")
    disk_size_gb         = optional(number)
  })
  description = "OS disk configuration."
  default     = {}
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = optional(string, "latest")
  })
  description = "Marketplace image reference."
}

variable "network_interface" {
  type = object({
    name                          = optional(string, "primary")
    enable_accelerated_networking = optional(bool, true)
    network_security_group_id     = optional(string)
    ip_configuration = object({
      name                                   = optional(string, "internal")
      load_balancer_backend_address_pool_ids = optional(list(string), [])
    })
  })
  description = "Network interface configuration."
  default = {
    name = "primary"
    ip_configuration = {
      name = "internal"
    }
  }
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity."
  default     = null
}

variable "boot_diagnostics" {
  type = object({
    storage_account_uri = string
  })
  description = "Boot diagnostics storage URI."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
