data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "this" {
  for_each = var.log_analytics_workspaces

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}
