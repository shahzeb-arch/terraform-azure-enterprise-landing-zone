common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_backup" = {
    resource_group_name     = "rg-dev-backup"
    resource_group_location = "East US"
    tags = {
      Environment = "Dev"
      Layer       = "backup"
    }
  }
}

recovery_services_vaults = {
  "rsv_platform" = {
    name               = "rsv-dev-platform"
    location           = "East US"
    resource_group_key = "rg_backup"
    storage_mode_type  = "GeoRedundant"
    tags = {
      Environment = "Dev"
    }
  }
}

backup_policies_vm = {
  "policy_vm_daily" = {
    name               = "bkpol-dev-vm-daily"
    resource_group_key = "rg_backup"
    recovery_vault_key = "rsv_platform"
    timezone           = "UTC"
    backup = {
      frequency = "Daily"
      time      = "23:00"
    }
    retention_daily = {
      count = 30
    }
    retention_weekly = {
      count = 12
    }
    retention_monthly = {
      count = 12
    }
    retention_yearly = {
      count = 7
    }
  }
}

site_recovery_replication_policies = {
  "asr_policy_default" = {
    name               = "asr-dev-default"
    resource_group_key = "rg_backup"
    recovery_vault_key = "rsv_platform"
  }
}

# Uncomment after compute VMs are deployed and paste VM resource IDs.
# backup_protected_vms = {
#   "vm_platform" = {
#     resource_group_key = "rg_backup"
#     recovery_vault_key = "rsv_platform"
#     backup_policy_key  = "policy_vm_daily"
#     source_vm_id       = "/subscriptions/.../providers/Microsoft.Compute/virtualMachines/vm-name"
#   }
# }
