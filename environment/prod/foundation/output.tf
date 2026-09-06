output "management_group_ids" {
  description = "Map of management group IDs."
  value       = { for k, m in module.management_group : k => m.id }
}

output "subscription_ids" {
  description = "Map of created subscription GUIDs."
  value       = { for k, m in module.subscription : k => m.subscription_id }
}

output "subscription_resource_ids" {
  description = "Map of created subscription resource IDs."
  value       = { for k, m in module.subscription : k => m.id }
}
