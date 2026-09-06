output "id" {
  description = "Redis cache ID."
  value       = azurerm_redis_cache.this.id
}

output "name" {
  description = "Redis cache name."
  value       = azurerm_redis_cache.this.name
}

output "hostname" {
  description = "Redis hostname."
  value       = azurerm_redis_cache.this.hostname
}

output "primary_access_key" {
  description = "Primary access key."
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
}
