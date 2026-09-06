data "azurerm_subnet" "this" {
  for_each = var.subnet_lookups

  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
