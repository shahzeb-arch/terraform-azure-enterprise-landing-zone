variable "name" {
  description = "Name of the Linux virtual machine scale set."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the VMSS will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the VMSS will be created."
  type        = string
}

variable "sku" {
  description = "VM size/SKU for VMSS instances."
  type        = string
}

variable "instances" {
  description = "Number of VMSS instances."
  type        = number

  validation {
    condition     = var.instances >= 0
    error_message = "instances must be greater than or equal to 0."
  }
}

variable "admin_username" {
  description = "Admin username for VMSS instances."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user."
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "Subnet ID where VMSS network interfaces will be placed."
  type        = string
}

variable "disable_password_authentication" {
  description = "Whether password authentication is disabled."
  type        = bool
  default     = true
}

variable "encryption_at_host_enabled" {
  description = "Whether encryption at host is enabled."
  type        = bool
  default     = true
}

variable "overprovision" {
  description = "Whether Azure should overprovision VMSS instances."
  type        = bool
  default     = false
}

variable "provision_vm_agent" {
  description = "Whether the Azure VM agent is provisioned."
  type        = bool
  default     = true
}

variable "secure_boot_enabled" {
  description = "Whether secure boot is enabled."
  type        = bool
  default     = true
}

variable "single_placement_group" {
  description = "Whether VMSS should use a single placement group."
  type        = bool
  default     = false
}

variable "upgrade_mode" {
  description = "VMSS upgrade mode."
  type        = string
  default     = "Manual"

  validation {
    condition     = contains(["Automatic", "Manual", "Rolling"], var.upgrade_mode)
    error_message = "upgrade_mode must be Automatic, Manual, or Rolling."
  }
}

variable "vtpm_enabled" {
  description = "Whether virtual TPM is enabled."
  type        = bool
  default     = true
}

variable "zones" {
  description = "Availability zones for VMSS instances."
  type        = list(string)
  default     = []
}

variable "os_disk" {
  description = "OS disk configuration."
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = optional(number)
  })
  default = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}

variable "source_image_reference" {
  description = "Source image reference for VMSS instances."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

variable "network_interface" {
  description = "Network interface configuration for VMSS instances."
  type = object({
    name                          = string
    enable_accelerated_networking = optional(bool, false)
    network_security_group_id     = optional(string)
    ip_configuration = object({
      name                                         = string
      application_gateway_backend_address_pool_ids = optional(list(string), [])
      load_balancer_backend_address_pool_ids       = optional(list(string), [])
      load_balancer_inbound_nat_rules_ids          = optional(list(string), [])
    })
  })
}

variable "identity" {
  description = "Optional managed identity configuration."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null

  validation {
    condition = var.identity == null || contains([
      "SystemAssigned",
      "UserAssigned",
      "SystemAssigned, UserAssigned"
    ], var.identity.type)
    error_message = "identity.type must be SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
  }
}

variable "boot_diagnostics" {
  description = "Optional boot diagnostics configuration."
  type = object({
    storage_account_uri = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the VMSS."
  type        = map(string)
  default     = {}
}
