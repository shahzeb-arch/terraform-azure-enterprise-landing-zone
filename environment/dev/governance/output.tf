output "management_group_ids" {
  description = "Management group IDs (Microsoft ALZ hierarchy)."
  value       = local.all_management_group_ids
}

output "subscription_ids" {
  description = "Created subscription GUIDs."
  value       = { for k, m in module.subscription : k => m.subscription_id }
}

output "subscription_resource_ids" {
  description = "Created subscription resource IDs."
  value       = { for k, m in module.subscription : k => m.id }
}

output "subscription_placement_ids" {
  description = "Existing subscription placement association IDs."
  value       = { for k, m in module.subscription_placement : k => m.id }
}

output "management_lock_ids" {
  description = "Management lock IDs."
  value       = { for k, m in module.management_lock : k => m.id }
}

output "policy_assignment_ids" {
  description = "Policy assignment IDs."
  value       = { for k, m in module.policy_assignment : k => m.id }
}

output "role_assignment_ids" {
  description = "Role assignment IDs."
  value       = { for k, m in module.role_assignment : k => m.id }
}

output "budget_ids" {
  description = "Budget IDs."
  value       = { for k, m in module.budget : k => m.id }
}

output "policy_definition_ids" {
  description = "Custom policy definition IDs."
  value       = { for k, m in module.policy : k => m.id }
}

output "initiative_ids" {
  description = "Policy initiative IDs."
  value       = { for k, m in module.initiative : k => m.id }
}

output "role_definition_ids" {
  description = "Custom role definition IDs."
  value       = { for k, m in module.role_definition : k => m.id }
}
