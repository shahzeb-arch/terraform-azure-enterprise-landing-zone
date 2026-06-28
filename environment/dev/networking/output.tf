output "rg_ids" {
  description = "List of resource group IDs"
  value       = [for k, v in module.resource_group : v.id]
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
  description = "Map of Subnet id"
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

output "network_interface_ids" {
  description = "Map of network interface IDs."
  value       = { for k, m in module.network_interface : k => m.id }
}

output "linux_virtual_machine_ids" {
  description = "Map of Linux virtual machine IDs."
  value       = { for k, m in module.linux_virtual_machine : k => m.id }
}

output "windows_virtual_machine_ids" {
  description = "Map of Windows virtual machine IDs."
  value       = { for k, m in module.windows_virtual_machine : k => m.id }
}

output "linux_vmss_ids" {
  description = "Map of Linux VMSS IDs."
  value       = { for k, m in module.linux_vmss : k => m.id }
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = { for k, m in module.nat_gateway : k => m.id }
}

output "nat_gateway_resource_guid" {
  description = "NAT Gateway resource GUID."
  value       = { for k, m in module.nat_gateway : k => m.resource_GUID }
}
