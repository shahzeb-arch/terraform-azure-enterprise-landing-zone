output "resource_group_ids" {
  description = "AKS layer resource group IDs."
  value       = { for k, m in module.resource_group : k => m.id }
}

output "aks_cluster_ids" {
  description = "AKS cluster resource IDs."
  value       = { for k, m in module.aks_cluster : k => m.id }
}

output "aks_cluster_names" {
  description = "AKS cluster names."
  value       = { for k, m in module.aks_cluster : k => m.name }
}

output "aks_private_fqdns" {
  description = "Private API server FQDNs."
  value       = { for k, m in module.aks_cluster : k => m.private_fqdn }
}

output "aks_oidc_issuer_urls" {
  description = "OIDC issuer URLs for workload identity."
  value       = { for k, m in module.aks_cluster : k => m.oidc_issuer_url }
}

output "aks_nodepool_ids" {
  description = "Worker node pool IDs."
  value       = { for k, m in module.aks_nodepool : k => m.id }
}

output "aks_extension_ids" {
  description = "AKS extension IDs."
  value       = { for k, m in module.aks_extension : k => m.id }
}
