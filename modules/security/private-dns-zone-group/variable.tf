variable "name" {
  type        = string
  description = "Private DNS zone group name."
  default     = "default"
}

variable "private_endpoint_id" {
  type        = string
  description = "Private endpoint resource ID."
}

variable "private_dns_zone_ids" {
  type        = list(string)
  description = "Private DNS zone resource IDs to associate."
}
