common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_management" = {
    resource_group_name     = "rg-prod-management"
    resource_group_location = "East US"
    tags = {
      Environment = "Prod"
    }
  }
}

automation_accounts = {
  "aa_platform" = {
    name               = "aa-prod-platform"
    location           = "East US"
    resource_group_key = "rg_management"
    tags = {
      Environment = "Prod"
    }
  }
}
