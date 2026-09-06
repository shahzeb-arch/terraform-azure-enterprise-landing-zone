variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all data layer resources."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  description = "Resource groups for the data layer."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "storage_accounts" {
  description = "Platform storage account definitions (diagnostics, boot logs, artifacts)."
  type = map(object({
    name                              = string
    location                          = string
    resource_group_key                = string
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "GRS")
    account_kind                      = optional(string, "StorageV2")
    access_tier                       = optional(string, "Hot")
    min_tls_version                   = optional(string, "TLS1_2")
    allow_nested_items_to_be_public   = optional(bool, false)
    shared_access_key_enabled         = optional(bool, false)
    public_network_access_enabled     = optional(bool, false)
    infrastructure_encryption_enabled = optional(bool, true)
    blob_properties = optional(object({
      versioning_enabled              = optional(bool, true)
      change_feed_enabled             = optional(bool, true)
      last_access_time_enabled        = optional(bool, true)
      delete_retention_days           = optional(number, 30)
      container_delete_retention_days = optional(number, 30)
    }), {})
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string), ["AzureServices"])
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "data_factories" {
  description = "Azure Data Factory definitions."
  type = map(object({
    name                            = string
    location                        = string
    resource_group_key              = string
    public_network_enabled          = optional(bool, false)
    managed_virtual_network_enabled = optional(bool, true)
    identity                        = optional(any)
    github_configuration            = optional(any)
    global_parameters               = optional(list(any), [])
    tags                            = optional(map(string), {})
  }))
  default = {}
}

variable "redis_caches" {
  description = "Azure Cache for Redis definitions."
  type = map(object({
    name                          = string
    location                      = string
    resource_group_key            = string
    capacity                      = optional(number, 1)
    family                        = optional(string, "C")
    sku_name                      = optional(string, "Standard")
    minimum_tls_version           = optional(string, "1.2")
    non_ssl_port_enabled          = optional(bool, false)
    public_network_access_enabled = optional(bool, false)
    redis_version                 = optional(string, "6")
    identity                      = optional(any)
    redis_configuration           = optional(any)
    patch_schedules               = optional(list(any), [])
    tags                          = optional(map(string), {})
  }))
  default = {}
}

variable "sql_servers" {
  description = "Azure SQL server definitions."
  type = map(object({
    name                                 = string
    location                             = string
    resource_group_key                   = string
    server_version                       = optional(string, "12.0")
    administrator_login                  = string
    administrator_login_password         = string
    minimum_tls_version                  = optional(string, "1.2")
    public_network_access_enabled        = optional(bool, false)
    outbound_network_restriction_enabled = optional(bool, true)
    identity                             = optional(any)
    azuread_administrator                = optional(any)
    tags                                 = optional(map(string), {})
  }))
  default = {}
}

variable "sql_databases" {
  description = "Azure SQL database definitions."
  type = map(object({
    name                        = string
    sql_server_key              = string
    collation                   = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    max_size_gb                 = optional(number, 32)
    sku_name                    = optional(string, "S0")
    zone_redundant              = optional(bool, false)
    long_term_retention_policy  = optional(any)
    short_term_retention_policy = optional(any)
    threat_detection_policy     = optional(any)
    tags                        = optional(map(string), {})
  }))
  default = {}
}

variable "cosmos_db_mongo_accounts" {
  description = "Cosmos DB MongoDB API account definitions."
  type = map(object({
    name                          = string
    location                      = string
    resource_group_key            = string
    offer_type                    = optional(string, "Standard")
    kind                          = optional(string, "MongoDB")
    mongo_server_version          = optional(string, "4.2")
    automatic_failover_enabled    = optional(bool, true)
    public_network_access_enabled = optional(bool, false)
    local_authentication_disabled = optional(bool, false)
    consistency_policy            = optional(any, {})
    geo_locations                 = list(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool, false)
    }))
    capabilities = optional(list(object({ name = string })), [{ name = "EnableMongo" }])
    identity     = optional(any)
    backup       = optional(any)
    tags         = optional(map(string), {})
  }))
  default = {}
}

variable "postgresql_flexible_servers" {
  description = "PostgreSQL flexible server definitions."
  type = map(object({
    name                          = string
    location                      = string
    resource_group_key            = string
    administrator_login           = string
    administrator_password        = string
    server_version                = optional(string, "16")
    sku_name                      = optional(string, "GP_Standard_D2s_v3")
    storage_mb                    = optional(number, 32768)
    backup_retention_days         = optional(number, 7)
    geo_redundant_backup_enabled  = optional(bool, true)
    zone                          = optional(string, "1")
    public_network_access_enabled = optional(bool, false)
    identity                      = optional(any)
    authentication                = optional(any)
    high_availability             = optional(any)
    maintenance_window            = optional(any)
    tags                          = optional(map(string), {})
  }))
  default = {}
}

variable "databricks_workspaces" {
  description = "Databricks workspace definitions."
  type = map(object({
    name                                  = string
    location                              = string
    resource_group_key                    = string
    sku                                   = optional(string, "premium")
    managed_resource_group_name           = string
    public_network_access_enabled         = optional(bool, false)
    network_security_group_rules_required = optional(string, "NoAzureDatabricksRules")
    custom_parameters                     = optional(any)
    tags                                  = optional(map(string), {})
  }))
  default = {}
}
