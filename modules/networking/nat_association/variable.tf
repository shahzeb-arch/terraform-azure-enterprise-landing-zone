variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to associate with the NAT Gateway."
}

variable "nat_gateway_id" {
  type        = string
  description = "The ID of the NAT Gateway."
}

variable "public_ip_address_ids" {
  type        = list(string)
  description = "Public IP address IDs to associate with the NAT Gateway for outbound traffic."
  default     = []
}
