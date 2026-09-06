output "id" {
  description = "AKS cluster resource ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "fqdn" {
  description = "FQDN of the API server."
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "private_fqdn" {
  description = "Private FQDN of the API server (private cluster)."
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "portal_fqdn" {
  description = "Portal FQDN for the cluster."
  value       = azurerm_kubernetes_cluster.this.portal_fqdn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "kubelet_identity" {
  description = "Kubelet managed identity block."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "identity" {
  description = "Cluster control plane managed identity."
  value       = azurerm_kubernetes_cluster.this.identity
}

output "node_resource_group" {
  description = "Auto-created node resource group name."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kubernetes_version" {
  description = "Kubernetes version running on the cluster."
  value       = azurerm_kubernetes_cluster.this.kubernetes_version
}

output "kube_config" {
  description = "Kubeconfig block (sensitive — use only for bootstrap/automation)."
  value       = azurerm_kubernetes_cluster.this.kube_config
  sensitive   = true
}
