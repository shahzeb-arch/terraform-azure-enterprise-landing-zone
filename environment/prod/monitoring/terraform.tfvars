common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_monitoring" = {
    resource_group_name     = "rg-prod-monitoring"
    resource_group_location = "East US"
    tags = {
      Environment = "Prod"
    }
  }
}

log_analytics_workspaces = {
  "law_platform" = {
    name               = "log-prod-platform"
    location           = "East US"
    resource_group_key = "rg_monitoring"
    retention_in_days  = 90
    tags = {
      Environment = "Prod"
    }
  }
}

action_groups = {
  "ag_platform" = {
    name               = "ag-prod-platform"
    resource_group_key = "rg_monitoring"
    short_name         = "devplat"
    email_receivers = [
      {
        name          = "platform-ops"
        email_address = "platform-ops@example.com"
      }
    ]
    tags = {
      Environment = "Prod"
    }
  }
}
