resource "azurerm_monitor_data_collection_rule" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = var.description
  tags                = var.tags

  dynamic "destinations" {
    for_each = [var.destinations]
    content {
      dynamic "log_analytics" {
        for_each = destinations.value.log_analytics
        content {
          name                  = log_analytics.value.name
          workspace_resource_id = log_analytics.value.workspace_resource_id
        }
      }

      dynamic "azure_monitor_metrics" {
        for_each = destinations.value.azure_monitor_metrics
        content {
          name = azure_monitor_metrics.value.name
        }
      }
    }
  }

  dynamic "data_flow" {
    for_each = var.data_flows
    content {
      streams       = data_flow.value.streams
      destinations  = data_flow.value.destinations
      transform_kql = data_flow.value.transform_kql
      output_stream = data_flow.value.output_stream
    }
  }

  dynamic "data_sources" {
    for_each = var.data_sources != null ? [var.data_sources] : []
    content {
      dynamic "performance_counter" {
        for_each = coalesce(data_sources.value.performance_counters, [])
        content {
          name                          = performance_counter.value.name
          streams                       = performance_counter.value.streams
          sampling_frequency_in_seconds = performance_counter.value.sampling_frequency_in_seconds
          counter_specifiers            = performance_counter.value.counter_specifiers
        }
      }

      dynamic "syslog" {
        for_each = coalesce(data_sources.value.syslogs, [])
        content {
          name           = syslog.value.name
          facility_names = syslog.value.facility_names
          log_levels     = syslog.value.log_levels
          streams        = syslog.value.streams
        }
      }

      dynamic "windows_event_log" {
        for_each = coalesce(data_sources.value.windows_event_logs, [])
        content {
          name           = windows_event_log.value.name
          streams        = windows_event_log.value.streams
          x_path_queries = windows_event_log.value.x_path_queries
        }
      }
    }
  }
}
