variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all backup resources."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  description = "Resource groups for the backup layer."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "recovery_services_vaults" {
  description = "Recovery Services Vault definitions."
  type = map(object({
    name                          = string
    location                      = string
    resource_group_key            = string
    sku                           = optional(string, "Standard")
    soft_delete_enabled           = optional(bool, true)
    public_network_access_enabled = optional(bool, false)
    cross_region_restore_enabled  = optional(bool, true)
    storage_mode_type             = optional(string, "GeoRedundant")
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "backup_policies_vm" {
  description = "VM backup policy definitions."
  type = map(object({
    name                = string
    resource_group_key  = string
    recovery_vault_key  = string
    timezone            = optional(string, "UTC")
    backup = object({
      frequency = string
      time      = string
      weekdays  = optional(list(string))
    })
    retention_daily = optional(object({
      count = number
    }))
    retention_weekly = optional(object({
      count    = number
      weekdays = optional(list(string), ["Sunday"])
    }))
    retention_monthly = optional(object({
      count    = number
      weekdays = optional(list(string), ["Sunday"])
      weeks    = optional(list(string), ["First"])
    }))
    retention_yearly = optional(object({
      count    = number
      weekdays = optional(list(string), ["Sunday"])
      weeks    = optional(list(string), ["First"])
      months   = optional(list(string), ["January"])
    }))
  }))
  default = {}
}

variable "backup_protected_vms" {
  description = "VMs to enroll in Azure Backup (set source_vm_id after compute layer deploy)."
  type = map(object({
    resource_group_key = string
    recovery_vault_key = string
    backup_policy_key  = string
    source_vm_id       = string
  }))
  default = {}
}

variable "site_recovery_replication_policies" {
  description = "ASR replication policies for disaster recovery."
  type = map(object({
    name                                                 = string
    resource_group_key                                   = string
    recovery_vault_key                                   = string
    recovery_point_retention_in_minutes                  = optional(number, 1440)
    application_consistent_snapshot_frequency_in_minutes = optional(number, 240)
  }))
  default = {}
}
