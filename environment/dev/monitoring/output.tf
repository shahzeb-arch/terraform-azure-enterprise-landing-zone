output "resource_group_ids" {
  description = "Monitoring resource group IDs."
  value       = { for k, m in module.resource_group : k => m.id }
}

output "log_analytics_workspace_ids" {
  description = "Log Analytics workspace IDs."
  value       = { for k, m in module.log_analytics : k => m.id }
}

output "action_group_ids" {
  description = "Action group IDs."
  value       = { for k, m in module.action_group : k => m.id }
}

output "data_collection_rule_ids" {
  description = "Data collection rule IDs."
  value       = { for k, m in module.data_collection_rule : k => m.id }
}

output "metric_alert_ids" {
  description = "Metric alert IDs."
  value       = { for k, m in module.metric_alert : k => m.id }
}
