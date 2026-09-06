output "rg_ids" {
  description = "Map of resource group key to ID."
  value       = { for k, m in module.resource_group : k => m.id }
}

output "vnet_ids" {
  description = "Map of VNet key to resource ID."
  value       = { for k, m in module.virtual_network : k => m.resource_id }
}

output "vnet_names" {
  description = "Map of VNet key to name."
  value       = { for k, m in module.virtual_network : k => m.name }
}

output "subnet_ids" {
  description = "Map of subnet key to ID."
  value       = { for k, m in module.subnet : k => m.id }
}

output "network_security_group_ids" {
  description = "Map of network security group IDs."
  value       = { for k, m in module.network_security_group : k => m.id }
}

output "route_table_ids" {
  description = "Map of route table IDs."
  value       = { for k, m in module.route_table : k => m.id }
}

output "nat_gateway_ids" {
  description = "Map of NAT Gateway IDs."
  value       = { for k, m in module.nat_gateway : k => m.id }
}

output "public_ip_ids" {
  description = "Map of public IP IDs."
  value       = { for k, m in module.public_ip : k => m.id }
}

output "private_dns_zone_ids" {
  description = "Private DNS zone IDs."
  value       = { for k, m in module.private_dns_zone : k => m.id }
}

output "private_dns_vnet_link_ids" {
  description = "Private DNS VNet link IDs."
  value       = { for k, m in module.private_dns_vnet_link : k => m.id }
}
