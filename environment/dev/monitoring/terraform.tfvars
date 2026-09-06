common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_monitoring" = {
    resource_group_name     = "rg-dev-monitoring"
    resource_group_location = "East US"
    tags = {
      Environment = "Dev"
    }
  }
}

log_analytics_workspaces = {
  "law_platform" = {
    name               = "log-dev-platform"
    location           = "East US"
    resource_group_key = "rg_monitoring"
    retention_in_days  = 90
    tags = {
      Environment = "Dev"
    }
  }
}

action_groups = {
  "ag_platform" = {
    name               = "ag-dev-platform"
    resource_group_key = "rg_monitoring"
    short_name         = "devplat"
    email_receivers = [
      {
        name          = "platform-ops"
        email_address = "platform-ops@example.com"
      }
    ]
    tags = {
      Environment = "Dev"
    }
  }
}

data_collection_rules = {
  "dcr_platform" = {
    name               = "dcr-dev-platform"
    location           = "East US"
    resource_group_key = "rg_monitoring"
    destinations = {
      log_analytics = [
        {
          name          = "law"
          workspace_key = "law_platform"
        }
      ]
    }
    data_flows = [
      {
        streams      = ["Microsoft-Perf"]
        destinations = ["law"]
      }
    ]
    data_sources = {
      performance_counters = [
        {
          name                          = "perf"
          streams                       = ["Microsoft-Perf"]
          sampling_frequency_in_seconds = 60
          counter_specifiers            = ["\\Processor(_Total)\\% Processor Time"]
        }
      ]
    }
    tags = {
      Environment = "Dev"
    }
  }
}

metric_alerts = {
  "law_ingestion_high" = {
    name                        = "alert-dev-law-ingestion"
    resource_group_key          = "rg_monitoring"
    log_analytics_workspace_key = "law_platform"
    action_group_keys           = ["ag_platform"]
    criteria = {
      metric_namespace = "Microsoft.OperationalInsights/workspaces"
      metric_name      = "Usage"
      aggregation      = "Total"
      operator         = "GreaterThan"
      threshold        = 10737418240
    }
    tags = {
      Environment = "Dev"
    }
  }
}
