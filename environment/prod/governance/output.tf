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
