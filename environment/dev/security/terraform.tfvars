common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_security" = {
    resource_group_name     = "rg-dev-security"
    resource_group_location = "East US"
    tags = {
      Environment = "Dev"
    }
  }
}

key_vaults = {
  "kv_platform" = {
    name               = "kv-dev-platform"
    location           = "East US"
    resource_group_key = "rg_security"
    tags = {
      Environment = "Dev"
    }
  }
}

managed_identities = {
  "id_platform" = {
    name               = "id-dev-platform"
    location           = "East US"
    resource_group_key = "rg_security"
    tags = {
      Environment = "Dev"
    }
  }
}

locks = {
  "lock_rg_security" = {
    name       = "lock-rg-dev-security"
    scope      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-dev-security"
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

subnet_lookups = {
  "snet-pe" = {
    subnet_name          = "snet-pe"
    virtual_network_name = "vnet-1"
    resource_group_name  = "rg-dev-network"
  }
}

# Uncomment after Key Vault key and DNS zones are provisioned.
# private_endpoints = {
#   "pe_kv" = {
#     name               = "pe-dev-kv"
#     location           = "East US"
#     resource_group_key = "rg_security"
#     subnet_key         = "snet-pe"
#     private_service_connection = {
#       name                           = "psc-kv"
#       private_connection_resource_id = "/subscriptions/.../providers/Microsoft.KeyVault/vaults/kv-dev-platform"
#       subresource_names              = ["vault"]
#     }
#   }
# }
