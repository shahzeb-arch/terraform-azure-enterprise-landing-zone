variable "name" {
  description = "Name of the Windows virtual machine."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the VM will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the VM will be created."
  type        = string
}

variable "size" {
  description = "Azure VM size."
  type        = string
}

variable "admin_username" {
  description = "Admin username for the Windows VM."
  type        = string
}

variable "admin_password" {
  description = "Admin password for the Windows VM."
  type        = string
  sensitive   = true
}

variable "network_interface_ids" {
  description = "Network interface IDs attached to the Windows VM."
  type        = list(string)
}

variable "encryption_at_host_enabled" {
  description = "Whether encryption at host is enabled."
  type        = bool
  default     = true
}

variable "patch_assessment_mode" {
  description = "Patch assessment mode."
  type        = string
  default     = "ImageDefault"
}

variable "patch_mode" {
  description = "Patch mode."
  type        = string
  default     = "AutomaticByOS"
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

variable "vtpm_enabled" {
  description = "Whether vTPM is enabled."
  type        = bool
  default     = true
}

variable "zone" {
  description = "Availability zone for the VM."
  type        = string
  default     = null
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
  description = "Source image reference."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

variable "identity" {
  description = "Optional managed identity configuration."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "boot_diagnostics" {
  description = "Optional boot diagnostics configuration."
  type = object({
    storage_account_uri = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the Windows VM."
  type        = map(string)
  default     = {}
}
