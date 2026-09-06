output "id" {
  description = "Cluster extension ID."
  value       = azurerm_kubernetes_cluster_extension.this.id
}

output "name" {
  description = "Cluster extension name."
  value       = azurerm_kubernetes_cluster_extension.this.name
}
