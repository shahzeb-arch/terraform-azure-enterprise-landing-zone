# Dev / security layer.
# Key Vault, managed identities, resource locks, and Defender plans.
module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/foundation/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "key_vault" {
  for_each = var.key_vaults
  source   = "../../../modules/security/key-vault"

  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  tenant_id           = coalesce(each.value.tenant_id, data.azurerm_client_config.current.tenant_id)
  tags                = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "managed_identity" {
  for_each = var.managed_identities
  source   = "../../../modules/security/managed-identity"

  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  tags                = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "lock" {
  for_each = var.locks
  source   = "../../../modules/security/locks"

  name       = each.value.name
  scope      = each.value.scope
  lock_level = each.value.lock_level
  notes      = each.value.notes
}

module "defender" {
  count  = var.defender_plans != null ? 1 : 0
  source = "../../../modules/security/defender"

  resource_types = var.defender_plans.resource_types
  tier           = var.defender_plans.tier
  subplans       = var.defender_plans.subplans
}

module "disk_encryption_set" {
  for_each = var.disk_encryption_sets
  source   = "../../../modules/security/disk-encryption-set"

  name                      = each.value.name
  location                  = each.value.location
  resource_group_name       = module.resource_group[each.value.resource_group_key].name
  key_vault_key_id          = each.value.key_vault_key_id
  encryption_type           = each.value.encryption_type
  auto_key_rotation_enabled = each.value.auto_key_rotation_enabled
  federated_client_id       = each.value.federated_client_id
  identity                  = each.value.identity
  tags                      = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "key_vault_key" {
  for_each = var.key_vault_keys
  source   = "../../../modules/security/key-vault-key"

  name            = each.value.name
  key_vault_id    = module.key_vault[each.value.key_vault_key].id
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  key_opts        = each.value.key_opts
  expiration_date = each.value.expiration_date
  rotation_policy = each.value.rotation_policy
  tags            = merge(var.common_tags, each.value.tags)

  depends_on = [module.key_vault]
}
