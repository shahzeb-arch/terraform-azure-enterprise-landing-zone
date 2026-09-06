common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_security" = {
    resource_group_name     = "rg-prod-security"
    resource_group_location = "East US"
    tags = {
      Environment = "Prod"
    }
  }
}

key_vaults = {
  "kv_platform" = {
    name               = "kv-prod-platform"
    location           = "East US"
    resource_group_key = "rg_security"
    tags = {
      Environment = "Prod"
    }
  }
}

managed_identities = {
  "id_platform" = {
    name               = "id-prod-platform"
    location           = "East US"
    resource_group_key = "rg_security"
    tags = {
      Environment = "Prod"
    }
  }
}

locks = {
  "lock_rg_security" = {
    name       = "lock-rg-prod-security"
    scope      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-prod-security"
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
