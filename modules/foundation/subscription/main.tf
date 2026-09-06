resource "azurerm_subscription" "this" {
  subscription_name = var.subscription_name
  billing_scope_id  = var.billing_scope_id
  alias             = var.alias
  tags              = var.tags
  workload          = var.workload
}