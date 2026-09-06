resource "azurerm_kubernetes_cluster_extension" "this" {
  name           = var.name
  cluster_id     = var.cluster_id
  extension_type = var.extension_type

  target_namespace                 = var.target_namespace
  release_train                    = var.release_train
  release_namespace                = var.release_namespace
  configuration_protected_settings = var.configuration_protected_settings
  configuration_settings           = var.configuration_settings

  dynamic "plan" {
    for_each = var.plan != null ? [var.plan] : []
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
      version   = plan.value.version
    }
  }
}
