# Dev / data layer.
# Secure storage accounts for diagnostics, boot logs, and platform data.
module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/foundation/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "storage_account" {
  for_each = var.storage_accounts
  source   = "../../../modules/data/storage-account"

  name                              = each.value.name
  location                          = each.value.location
  resource_group_name               = module.resource_group[each.value.resource_group_key].name
  account_tier                      = each.value.account_tier
  account_replication_type          = each.value.account_replication_type
  account_kind                      = each.value.account_kind
  access_tier                       = each.value.access_tier
  min_tls_version                   = each.value.min_tls_version
  allow_nested_items_to_be_public   = each.value.allow_nested_items_to_be_public
  shared_access_key_enabled         = each.value.shared_access_key_enabled
  public_network_access_enabled     = each.value.public_network_access_enabled
  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
  blob_properties                   = each.value.blob_properties
  identity                          = each.value.identity
  network_rules                     = each.value.network_rules
  tags                              = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "data_factory" {
  for_each = var.data_factories
  source   = "../../../modules/data/data-factory"

  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = module.resource_group[each.value.resource_group_key].name
  public_network_enabled          = each.value.public_network_enabled
  managed_virtual_network_enabled = each.value.managed_virtual_network_enabled
  identity                        = each.value.identity
  github_configuration            = each.value.github_configuration
  global_parameters               = each.value.global_parameters
  tags                            = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "redis_cache" {
  for_each = var.redis_caches
  source   = "../../../modules/data/redis-cache"

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  capacity                      = each.value.capacity
  family                        = each.value.family
  sku_name                      = each.value.sku_name
  minimum_tls_version           = each.value.minimum_tls_version
  non_ssl_port_enabled          = each.value.non_ssl_port_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  redis_version                 = each.value.redis_version
  identity                      = each.value.identity
  redis_configuration           = each.value.redis_configuration
  patch_schedules               = each.value.patch_schedules
  tags                          = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "sql_server" {
  for_each = var.sql_servers
  source   = "../../../modules/data/sql-server"

  name                                 = each.value.name
  location                             = each.value.location
  resource_group_name                  = module.resource_group[each.value.resource_group_key].name
  server_version                              = each.value.server_version
  administrator_login                  = each.value.administrator_login
  administrator_login_password         = each.value.administrator_login_password
  minimum_tls_version                  = each.value.minimum_tls_version
  public_network_access_enabled        = each.value.public_network_access_enabled
  outbound_network_restriction_enabled = each.value.outbound_network_restriction_enabled
  identity                             = each.value.identity
  azuread_administrator                = each.value.azuread_administrator
  tags                                 = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "sql_database" {
  for_each = var.sql_databases
  source   = "../../../modules/data/sql-database"

  name                        = each.value.name
  server_id                   = module.sql_server[each.value.sql_server_key].id
  collation                   = each.value.collation
  max_size_gb                 = each.value.max_size_gb
  sku_name                    = each.value.sku_name
  zone_redundant              = each.value.zone_redundant
  long_term_retention_policy  = each.value.long_term_retention_policy
  short_term_retention_policy = each.value.short_term_retention_policy
  threat_detection_policy     = each.value.threat_detection_policy
  tags                        = merge(var.common_tags, each.value.tags)

  depends_on = [module.sql_server]
}

module "cosmos_db_mongo" {
  for_each = var.cosmos_db_mongo_accounts
  source   = "../../../modules/data/cosmos-db-mongo"

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  offer_type                    = each.value.offer_type
  kind                          = each.value.kind
  mongo_server_version          = each.value.mongo_server_version
  automatic_failover_enabled    = each.value.automatic_failover_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  local_authentication_disabled = each.value.local_authentication_disabled
  consistency_policy            = each.value.consistency_policy
  geo_locations                 = each.value.geo_locations
  capabilities                  = each.value.capabilities
  identity                      = each.value.identity
  backup                        = each.value.backup
  tags                          = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "postgresql_flexible_server" {
  for_each = var.postgresql_flexible_servers
  source   = "../../../modules/data/postgresql-flexible-server"

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  administrator_login           = each.value.administrator_login
  administrator_password        = each.value.administrator_password
  server_version                = each.value.server_version
  sku_name                      = each.value.sku_name
  storage_mb                    = each.value.storage_mb
  backup_retention_days         = each.value.backup_retention_days
  geo_redundant_backup_enabled  = each.value.geo_redundant_backup_enabled
  zone                          = each.value.zone
  public_network_access_enabled = each.value.public_network_access_enabled
  identity                      = each.value.identity
  authentication                = each.value.authentication
  high_availability             = each.value.high_availability
  maintenance_window            = each.value.maintenance_window
  tags                          = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "databricks_workspace" {
  for_each = var.databricks_workspaces
  source   = "../../../modules/data/databricks-workspace"

  name                                  = each.value.name
  location                              = each.value.location
  resource_group_name                   = module.resource_group[each.value.resource_group_key].name
  sku                                   = each.value.sku
  managed_resource_group_name           = each.value.managed_resource_group_name
  public_network_access_enabled         = each.value.public_network_access_enabled
  network_security_group_rules_required = each.value.network_security_group_rules_required
  custom_parameters                     = each.value.custom_parameters
  tags                                  = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}
