output "sentinel_onboarding_ids" {
  description = "Sentinel onboarding resource IDs."
  value       = { for k, v in module.sentinel : k => v.onboarding_id }
}
