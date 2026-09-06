common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_management" = {
    resource_group_name     = "rg-dev-management"
    resource_group_location = "East US"
    tags = {
      Environment = "Dev"
    }
  }
}

automation_accounts = {
  "aa_platform" = {
    name               = "aa-dev-platform"
    location           = "East US"
    resource_group_key = "rg_management"
    tags = {
      Environment = "Dev"
    }
  }
}
