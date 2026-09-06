resource "azurerm_linux_function_app" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key   = var.storage_account_access_key
  https_only          = var.https_only
  tags                = var.tags

  site_config {
    always_on                               = var.site_config.always_on
    minimum_tls_version                     = var.site_config.minimum_tls_version
    ftps_state                              = var.site_config.ftps_state
    http2_enabled                           = var.site_config.http2_enabled
    vnet_route_all_enabled                  = var.site_config.vnet_route_all_enabled
    application_insights_connection_string  = var.site_config.application_insights_connection_string
    application_insights_key                = var.site_config.application_insights_key

    dynamic "application_stack" {
      for_each = var.site_config.application_stack != null ? [var.site_config.application_stack] : []
      content {
        dotnet_version              = application_stack.value.dotnet_version
        node_version                = application_stack.value.node_version
        python_version              = application_stack.value.python_version
        java_version                = application_stack.value.java_version
        powershell_core_version     = application_stack.value.powershell_core_version
        use_dotnet_isolated_runtime = application_stack.value.use_dotnet_isolated_runtime
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  app_settings = var.app_settings
}
