resource "azurerm_management_group_subscription_association" "this" {
  management_group_id = var.management_group_id
  subscription_id     = var.subscription_id
}
