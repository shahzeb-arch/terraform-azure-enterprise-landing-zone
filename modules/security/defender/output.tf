output "ids" {
  description = "Map of resource type to Defender pricing resource ID."
  value       = { for k, v in azurerm_security_center_subscription_pricing.this : k => v.id }
}

output "resource_types" {
  description = "Enabled Defender resource types."
  value       = keys(azurerm_security_center_subscription_pricing.this)
}
