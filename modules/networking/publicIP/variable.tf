variable "public_ip_name" {
    type        = string
    description = "The name of the Public IP Address."
  
}
variable "resource_group_name" {
    type        = string
    description = "The name of the Resource Group."
  
}
variable "location" {
    type        = string
    description = "The location of the Public IP Address."
  
}
variable "allocation_method" {
    type        = string
    description = "The allocation method of the Public IP Address."
    default = "static"
  
}
variable "zones" {
    type        = list(string)
    description = "The availability zones of the Public IP Address."
    default     = null
  
}
variable "ddos_protection_mode" {
    type        = string
    description = "The DDoS protection mode of the Public IP Address."
    default     = null
  
}
variable "ddos_protection_plan_id" {
    type        = string
    description = "The ID of the DDoS protection plan associated with the Public IP Address."
    default     = virtualNetworkInherited ? null : null
}
variable "domain_name_label" {
    type        = string
    description = "The domain name label of the Public IP Address."
    default     = null
  
}
variable "domain_name_label_scope" {
    type        = string
    description = "The domain name label scope of the Public IP Address."
    default     = null
  
}
variable "edge_zone" {
    type        = string
    description = "The edge zone of the Public IP Address."
    default     = null
}
variable "idle_timeout_in_minutes" {
    type        = number
    description = "The idle timeout in minutes of the Public IP Address."
    default     = 4
}
variable "ip_tags" {
    type        = map(string)
    description = "A map of IP tags to assign to the Public IP Address."
    default     = {}
}
variable "ip_version" {
    type        = string
    description = "The IP version of the Public IP Address."
    default     = "IPv4"
}
variable "public_ip_prefix_id" {
    type        = string
    description = "The ID of the Public IP Prefix associated with the Public IP Address."
    default     = null
}
variable "reverse_fqdn" {
    type        = string
    description = "The reverse FQDN of the Public IP Address."
    default     = null
}
variable "sku" {
    type        = string
    description = "The SKU of the Public IP Address."
    default     = "Standard"
}
variable "sku_tier" {
    type        = string
    description = "The SKU tier of the Public IP Address."
    default     = "Regional"
}
variable "tags" {
    type        = map(string)
    description = "A map of tags to assign to the Public IP Address."
    default     = {}
}