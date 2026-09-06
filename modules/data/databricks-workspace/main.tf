resource "azurerm_databricks_workspace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  managed_resource_group_name = var.managed_resource_group_name
  public_network_access_enabled = var.public_network_access_enabled
  network_security_group_rules_required = var.network_security_group_rules_required
  tags                = var.tags

  dynamic "custom_parameters" {
    for_each = var.custom_parameters != null ? [var.custom_parameters] : []
    content {
      no_public_ip                                         = custom_parameters.value.no_public_ip
      virtual_network_id                                   = custom_parameters.value.virtual_network_id
      public_subnet_name                                   = custom_parameters.value.public_subnet_name
      private_subnet_name                                  = custom_parameters.value.private_subnet_name
      public_subnet_network_security_group_association_id  = custom_parameters.value.public_subnet_network_security_group_association_id
      private_subnet_network_security_group_association_id = custom_parameters.value.private_subnet_network_security_group_association_id
      storage_account_name                                 = custom_parameters.value.storage_account_name
      storage_account_sku_name                               = custom_parameters.value.storage_account_sku_name
    }
  }
}
