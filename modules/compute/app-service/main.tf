resource "azurerm_linux_web_app" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  https_only          = var.https_only
  client_affinity_enabled = var.client_affinity_enabled
  tags                = var.tags

  site_config {
    always_on                               = var.site_config.always_on
    minimum_tls_version                     = var.site_config.minimum_tls_version
    ftps_state                              = var.site_config.ftps_state
    http2_enabled                           = var.site_config.http2_enabled
    vnet_route_all_enabled                  = var.site_config.vnet_route_all_enabled
    health_check_path = var.site_config.health_check_path

    dynamic "application_stack" {
      for_each = var.site_config.application_stack != null ? [var.site_config.application_stack] : []
      content {
        dotnet_version = application_stack.value.dotnet_version
        java_version   = application_stack.value.java_version
        node_version   = application_stack.value.node_version
        python_version = application_stack.value.python_version
        php_version    = application_stack.value.php_version
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

  dynamic "auth_settings_v2" {
    for_each = var.auth_settings_v2 != null ? [var.auth_settings_v2] : []
    content {
      auth_enabled           = auth_settings_v2.value.auth_enabled
      require_authentication = auth_settings_v2.value.require_authentication
      unauthenticated_action = auth_settings_v2.value.unauthenticated_action

      dynamic "login" {
        for_each = coalesce(auth_settings_v2.value.logins, [])
        content {
          token_store_enabled = login.value.token_store_enabled
        }
      }
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

  dynamic "sticky_settings" {
    for_each = var.sticky_settings != null ? [var.sticky_settings] : []
    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }

  app_settings = var.app_settings
}
