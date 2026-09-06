output "prefix" {
  description = "org-env-region prefix."
  value       = local.prefix
}

output "base" {
  description = "org-env-region-workload base name."
  value       = local.base
}

output "slug" {
  description = "Full slug with optional suffix."
  value       = local.slug
}

output "resource_group" {
  description = "Standard resource group name."
  value       = "rg-${local.slug}"
}

output "virtual_network" {
  description = "Standard virtual network name."
  value       = "vnet-${local.slug}"
}

output "subnet" {
  description = "Standard subnet name (append purpose when calling)."
  value       = "snet-${local.slug}"
}

output "key_vault" {
  description = "Standard Key Vault name (alphanumeric, max 24)."
  value       = substr(replace("kv-${local.slug_rg}", "-", ""), 0, 24)
}

output "log_analytics" {
  description = "Standard Log Analytics workspace name."
  value       = "log-${local.slug}"
}

output "firewall" {
  description = "Standard Azure Firewall name."
  value       = "afw-${local.slug}"
}

output "bastion" {
  description = "Standard Bastion host name."
  value       = "bas-${local.slug}"
}

output "managed_identity" {
  description = "Standard managed identity name."
  value       = "id-${local.slug}"
}
