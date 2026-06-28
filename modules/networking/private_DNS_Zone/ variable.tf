variable "private_dns_zone_name"  {
    type        = string
    description = "The name of the Private DNS Zone."

}

variable "resource_group_name" {
    type        = string
    description = "The name of the Resource Group."
}

variable "soa_record" {
    type = object({
        email                        = string
        expire_time_in_seconds       = number
        minimum_ttl_in_seconds       = number
        refresh_time_in_seconds      = number
        retry_time_in_seconds        = number
        ttl_in_seconds               = number
        soa_tags                        = map(string)
    })
    validation {

  condition = var.soa_record == null ||
              can(regex(".+@.+", var.soa_record.email))

  error_message = "Invalid SOA email."

}
    description = "The SOA record for the Private DNS Zone."

    default = null
}

variable "tags" {
    type = map(string)
    description = "A map of tags to assign to the Private DNS Zone."

    default = {}
}