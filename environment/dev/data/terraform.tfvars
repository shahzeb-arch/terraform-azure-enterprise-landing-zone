common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_data" = {
    resource_group_name     = "rg-dev-data"
    resource_group_location = "East US"
    tags = {
      Environment = "Dev"
      Layer       = "data"
    }
  }
}

storage_accounts = {
  "st_platform" = {
    name               = "stdevplatform001"
    location           = "East US"
    resource_group_key = "rg_data"
    account_tier       = "Standard"
    account_replication_type = "GRS"
    public_network_access_enabled = false
    shared_access_key_enabled     = false
    tags = {
      Environment = "Dev"
      Purpose     = "PlatformDiagnostics"
    }
  }
}
