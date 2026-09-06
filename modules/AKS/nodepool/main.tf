resource "azurerm_kubernetes_cluster_node_pool" "this" {
  name                  = var.name
  kubernetes_cluster_id = var.kubernetes_cluster_id
  vm_size               = var.vm_size
  vnet_subnet_id        = var.subnet_id
  mode                  = var.mode
  os_type               = var.os_type
  os_sku                = var.os_sku
  priority              = var.priority
  eviction_policy       = var.eviction_policy
  spot_max_price        = var.spot_max_price
  node_count            = var.auto_scaling_enabled ? null : var.node_count
  auto_scaling_enabled  = var.auto_scaling_enabled
  min_count             = var.auto_scaling_enabled ? var.min_count : null
  max_count             = var.auto_scaling_enabled ? var.max_count : null
  os_disk_size_gb       = var.os_disk_size_gb
  os_disk_type          = var.os_disk_type
  zones                 = var.zones
  max_pods              = var.max_pods
  node_labels           = var.node_labels
  node_taints           = var.node_taints
  tags                  = var.tags

  dynamic "upgrade_settings" {
    for_each = var.upgrade_settings != null ? [var.upgrade_settings] : []
    content {
      max_surge                     = upgrade_settings.value.max_surge
      drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
      node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes
    }
  }

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
}
