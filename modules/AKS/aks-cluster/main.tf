resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier
  tags                = var.tags

  # Private cluster (production default)
  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled

  local_account_disabled           = var.local_account_disabled
  azure_policy_enabled             = var.azure_policy_enabled
  oidc_issuer_enabled              = var.oidc_issuer_enabled
  workload_identity_enabled        = var.workload_identity_enabled
  image_cleaner_enabled            = var.image_cleaner_enabled
  http_application_routing_enabled = var.http_application_routing_enabled
  cost_analysis_enabled            = var.cost_analysis_enabled

  # System node pool (required — runs critical addons; Azure-managed control plane is separate)
  default_node_pool {
    name                         = var.system_node_pool.name
    vm_size                      = var.system_node_pool.vm_size
    vnet_subnet_id               = var.system_node_pool.subnet_id
    node_count                   = var.system_node_pool.enable_auto_scaling ? null : var.system_node_pool.node_count
    auto_scaling_enabled         = var.system_node_pool.enable_auto_scaling
    min_count                    = var.system_node_pool.enable_auto_scaling ? var.system_node_pool.min_count : null
    max_count                    = var.system_node_pool.enable_auto_scaling ? var.system_node_pool.max_count : null
    os_disk_size_gb              = var.system_node_pool.os_disk_size_gb
    os_disk_type                 = var.system_node_pool.os_disk_type
    os_sku                       = var.system_node_pool.os_sku
    zones                        = var.system_node_pool.zones
    max_pods                     = var.system_node_pool.max_pods
    only_critical_addons_enabled = true
    type                         = "VirtualMachineScaleSets"

    dynamic "upgrade_settings" {
      for_each = var.system_node_pool.upgrade_settings != null ? [var.system_node_pool.upgrade_settings] : []
      content {
        max_surge                     = upgrade_settings.value.max_surge
        drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
        node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes
      }
    }
  }

  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_plugin_mode = var.network_profile.network_plugin_mode
    network_policy      = var.network_profile.network_policy
    outbound_type       = var.network_profile.outbound_type
    load_balancer_sku   = var.network_profile.load_balancer_sku
    service_cidr        = var.network_profile.service_cidr
    dns_service_ip      = var.network_profile.dns_service_ip
    pod_cidr            = var.network_profile.pod_cidr
  }

  identity {
    type         = var.identity.type
    identity_ids = var.identity.type == "UserAssigned" ? var.identity.identity_ids : null
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.rbac.azure_rbac_enabled
    admin_group_object_ids = var.rbac.admin_group_object_ids
    tenant_id              = var.rbac.tenant_id
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider != null ? [var.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []
    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = maintenance_window.value.not_allowed
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.maintenance_window_auto_upgrade != null ? [var.maintenance_window_auto_upgrade] : []
    content {
      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      duration     = maintenance_window_auto_upgrade.value.duration
      day_of_week  = maintenance_window_auto_upgrade.value.day_of_week
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      week_index   = maintenance_window_auto_upgrade.value.week_index
      start_time   = maintenance_window_auto_upgrade.value.start_time
      utc_offset   = maintenance_window_auto_upgrade.value.utc_offset
      start_date   = maintenance_window_auto_upgrade.value.start_date

      dynamic "not_allowed" {
        for_each = maintenance_window_auto_upgrade.value.not_allowed != null ? [maintenance_window_auto_upgrade.value.not_allowed] : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = var.maintenance_window_node_os != null ? [var.maintenance_window_node_os] : []
    content {
      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      duration     = maintenance_window_node_os.value.duration
      day_of_week  = maintenance_window_node_os.value.day_of_week
      day_of_month = maintenance_window_node_os.value.day_of_month
      week_index   = maintenance_window_node_os.value.week_index
      start_time   = maintenance_window_node_os.value.start_time
      utc_offset   = maintenance_window_node_os.value.utc_offset
      start_date   = maintenance_window_node_os.value.start_date

      dynamic "not_allowed" {
        for_each = maintenance_window_node_os.value.not_allowed != null ? [maintenance_window_node_os.value.not_allowed] : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile != null ? [var.auto_scaler_profile] : []
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                         = auto_scaler_profile.value.expander
      max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
      scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready               = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      scan_interval                    = auto_scaler_profile.value.scan_interval
      skip_nodes_with_local_storage    = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods      = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  lifecycle {
    ignore_changes = [
      kubernetes_version,
      default_node_pool[0].node_count,
    ]
  }
}
