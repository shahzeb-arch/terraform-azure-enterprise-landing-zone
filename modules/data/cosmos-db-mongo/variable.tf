variable "name" {
  type        = string
  description = "Cosmos DB account name."
}

variable "location" {
  type        = string
  description = "Primary Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "offer_type" {
  type        = string
  description = "Cosmos DB offer type."
  default     = "Standard"
}

variable "kind" {
  type        = string
  description = "Cosmos DB API kind (MongoDB, GlobalDocumentDB, etc.)."
  default     = "MongoDB"
}

variable "mongo_server_version" {
  type        = string
  description = "MongoDB server version (4.0, 4.2, etc.)."
  default     = "4.2"
}

variable "automatic_failover_enabled" {
  type        = bool
  description = "Enable automatic failover."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public network access."
  default     = false
}

variable "local_authentication_disabled" {
  type        = bool
  description = "Disable local key authentication (use AAD only)."
  default     = false
}

variable "consistency_policy" {
  type = object({
    consistency_level       = optional(string, "Session")
    max_interval_in_seconds = optional(number, 5)
    max_staleness_prefix    = optional(number, 100)
  })
  description = "Consistency policy."
  default     = {}
}

variable "geo_locations" {
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
  description = "Geo-replication locations."
}

variable "capabilities" {
  type = list(object({
    name = string
  }))
  description = "Cosmos DB capabilities (e.g. EnableMongo)."
  default = [
    { name = "EnableMongo" }
  ]
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "Managed identity configuration."
  default     = null
}

variable "backup" {
  type = object({
    type                = optional(string, "Continuous")
    interval_in_minutes = optional(number)
    retention_in_hours  = optional(number)
    storage_redundancy  = optional(string)
  })
  description = "Backup policy."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
