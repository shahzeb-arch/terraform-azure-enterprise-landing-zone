resource "azurerm_redis_cache" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  minimum_tls_version = var.minimum_tls_version
  non_ssl_port_enabled = var.non_ssl_port_enabled
  public_network_access_enabled = var.public_network_access_enabled
  redis_version       = var.redis_version
  tags                = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "redis_configuration" {
    for_each = var.redis_configuration != null ? [var.redis_configuration] : []
    content {
      maxmemory_policy                = redis_configuration.value.maxmemory_policy
      maxmemory_reserved              = redis_configuration.value.maxmemory_reserved
      maxmemory_delta                 = redis_configuration.value.maxmemory_delta
      maxfragmentationmemory_reserved = redis_configuration.value.maxfragmentationmemory_reserved
    }
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedules
    content {
      day_of_week    = patch_schedule.value.day_of_week
      start_hour_utc = patch_schedule.value.start_hour_utc
    }
  }
}
