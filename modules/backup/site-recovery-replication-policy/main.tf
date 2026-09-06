resource "azurerm_site_recovery_replication_policy" "this" {
  name                                                 = var.name
  resource_group_name                                  = var.resource_group_name
  recovery_vault_name                                  = var.recovery_vault_name
  recovery_point_retention_in_minutes                  = var.recovery_point_retention_in_minutes
  application_consistent_snapshot_frequency_in_minutes = var.application_consistent_snapshot_frequency_in_minutes
}
