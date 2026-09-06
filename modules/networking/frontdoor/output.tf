output "profile_id" {
  description = "Front Door profile ID."
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "endpoint_ids" {
  description = "Front Door endpoint IDs."
  value       = { for k, v in azurerm_cdn_frontdoor_endpoint.this : k => v.id }
}

output "waf_policy_id" {
  description = "Front Door WAF policy ID when enabled."
  value       = try(azurerm_cdn_frontdoor_firewall_policy.this[0].id, null)
}
