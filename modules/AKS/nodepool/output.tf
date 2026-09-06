output "id" {
  description = "Node pool resource ID."
  value       = azurerm_kubernetes_cluster_node_pool.this.id
}

output "name" {
  description = "Node pool name."
  value       = azurerm_kubernetes_cluster_node_pool.this.name
}

output "mode" {
  description = "Node pool mode (User or System)."
  value       = azurerm_kubernetes_cluster_node_pool.this.mode
}

output "node_count" {
  description = "Current node count (null when auto-scaling is enabled)."
  value       = azurerm_kubernetes_cluster_node_pool.this.node_count
}

output "kubernetes_cluster_id" {
  description = "Parent AKS cluster ID."
  value       = azurerm_kubernetes_cluster_node_pool.this.kubernetes_cluster_id
}
