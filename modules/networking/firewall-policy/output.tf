output "id" {
  description = "Firewall Policy resource ID."
  value       = azurerm_firewall_policy.this.id
}

output "name" {
  description = "Firewall Policy name."
  value       = azurerm_firewall_policy.this.name
}

output "rule_collection_group_id" {
  description = "Rule collection group ID when configured."
  value       = var.rule_collection_group != null ? azurerm_firewall_policy_rule_collection_group.this[0].id : null
}
