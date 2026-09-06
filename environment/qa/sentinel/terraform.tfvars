log_analytics_workspaces = {
  "law_platform" = {
    name                = "log-qa-platform"
    resource_group_name = "rg-qa-monitoring"
  }
}

sentinel_onboarding = {
  "platform" = {
    workspace_lookup_key      = "law_platform"
    enable_aad_data_connector = true
  }
}
