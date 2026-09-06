# Dev / backup layer.
# Recovery Services Vault, VM backup policies, and optional ASR replication policy.
module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/foundation/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "recovery_services_vault" {
  for_each = var.recovery_services_vaults
  source   = "../../../modules/backup/recovery-services-vault"

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  sku                           = each.value.sku
  soft_delete_enabled           = each.value.soft_delete_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  cross_region_restore_enabled  = each.value.cross_region_restore_enabled
  storage_mode_type             = each.value.storage_mode_type
  identity                      = each.value.identity
  tags                          = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "backup_policy_vm" {
  for_each = var.backup_policies_vm
  source   = "../../../modules/backup/backup-policy-vm"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  recovery_vault_name = module.recovery_services_vault[each.value.recovery_vault_key].name
  timezone            = each.value.timezone
  backup              = each.value.backup
  retention_daily     = each.value.retention_daily
  retention_weekly    = each.value.retention_weekly
  retention_monthly   = each.value.retention_monthly
  retention_yearly    = each.value.retention_yearly

  depends_on = [module.recovery_services_vault]
}

module "backup_protected_vm" {
  for_each = var.backup_protected_vms
  source   = "../../../modules/backup/backup-protected-vm"

  resource_group_name = module.resource_group[each.value.resource_group_key].name
  recovery_vault_name = module.recovery_services_vault[each.value.recovery_vault_key].name
  source_vm_id        = each.value.source_vm_id
  backup_policy_id    = module.backup_policy_vm[each.value.backup_policy_key].id

  depends_on = [module.backup_policy_vm, module.recovery_services_vault]
}

module "site_recovery_replication_policy" {
  for_each = var.site_recovery_replication_policies
  source   = "../../../modules/backup/site-recovery-replication-policy"

  name                                                 = each.value.name
  resource_group_name                                  = module.resource_group[each.value.resource_group_key].name
  recovery_vault_name                                  = module.recovery_services_vault[each.value.recovery_vault_key].name
  recovery_point_retention_in_minutes                  = each.value.recovery_point_retention_in_minutes
  application_consistent_snapshot_frequency_in_minutes = each.value.application_consistent_snapshot_frequency_in_minutes

  depends_on = [module.recovery_services_vault]
}
