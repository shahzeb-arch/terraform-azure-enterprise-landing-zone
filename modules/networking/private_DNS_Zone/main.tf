resource "azurerm_private_dns_zone" "example" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags = var.tags
  dynamic "soa_record" {
    for_each = var.soa_record != null ? [var.soa_record] : []
    content {
      email = soa_record.value.email
      expire_time = soa_record.value.expire_time_in_seconds
      minimum_ttl = soa_record.value.minimum_ttl_in_seconds
      refresh_time = soa_record.value.refresh_time_in_seconds
      retry_time = soa_record.value.retry_time_in_seconds
      ttl = soa_record.value.ttl_in_seconds
      tags = var.soa_record != null ? var.soa_record.soa_tags : {}
    }
  }
}