variable "nat_gateway_name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "sku_name" {
  type = string
  default = "Standard"
}
variable "idle_timeout_in_minutes" {
  type = optional(number)
    default = 10
}
variable "zones" {
  type = optional(list(string))
    default = ["1"]
}
variable "tags" {
  type = optional(map(string))
    default = {}
}