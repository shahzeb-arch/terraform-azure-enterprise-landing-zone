variable "name" {
  type        = string
  description = "Log Analytics workspace name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku" {
  type        = string
  description = "PerGB2018 recommended for production."
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "Log retention days (30-730)."
  default     = 90
}

variable "daily_quota_gb" {
  type        = number
  description = "Daily ingestion cap in GB (-1 = unlimited)."
  default     = -1
}

variable "internet_ingestion_enabled" {
  type        = bool
  description = "Allow public internet ingestion."
  default     = false
}

variable "internet_query_enabled" {
  type        = bool
  description = "Allow public internet query."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
