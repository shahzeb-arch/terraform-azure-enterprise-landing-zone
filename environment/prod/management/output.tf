output "automation_account_ids" {
  description = "Automation account resource IDs."
  value       = { for k, v in module.automation_account : k => v.id }
}
