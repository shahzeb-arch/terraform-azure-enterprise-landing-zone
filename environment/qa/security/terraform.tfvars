common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_security" = {
    resource_group_name     = "rg-qa-security"
    resource_group_location = "East US"
    tags = {
      Environment = "Qa"
    }
  }
}

key_vaults = {
  "kv_platform" = {
    name               = "kv-qa-platform"
    location           = "East US"
    resource_group_key = "rg_security"
    tags = {
      Environment = "Qa"
    }
  }
}

managed_identities = {
  "id_platform" = {
    name               = "id-qa-platform"
    location           = "East US"
    resource_group_key = "rg_security"
    tags = {
      Environment = "Qa"
    }
  }
}

locks = {
  "lock_rg_security" = {
    name       = "lock-rg-qa-security"
    scope      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-qa-security"
    lock_level = "CanNotDelete"
  }
}

defender_plans = {
  resource_types = [
    "VirtualMachines",
    "StorageAccounts",
    "SqlServers",
    "KeyVaults",
    "ContainerRegistry",
  ]
  tier = "Standard"
}
