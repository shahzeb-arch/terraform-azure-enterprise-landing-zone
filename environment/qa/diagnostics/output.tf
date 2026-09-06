output "diagnostic_setting_ids" {
  description = "Diagnostic setting resource IDs."
  value       = { for k, v in module.diagnostics : k => v.id }
}
