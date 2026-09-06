common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_monitoring" = {
    resource_group_name     = "rg-qa-monitoring"
    resource_group_location = "East US"
    tags = {
      Environment = "Qa"
    }
  }
}

log_analytics_workspaces = {
  "law_platform" = {
    name               = "log-qa-platform"
    location           = "East US"
    resource_group_key = "rg_monitoring"
    retention_in_days  = 90
    tags = {
      Environment = "Qa"
    }
  }
}

action_groups = {
  "ag_platform" = {
    name               = "ag-qa-platform"
    resource_group_key = "rg_monitoring"
    short_name         = "devplat"
    email_receivers = [
      {
        name          = "platform-ops"
        email_address = "platform-ops@example.com"
      }
    ]
    tags = {
      Environment = "Qa"
    }
  }
}
