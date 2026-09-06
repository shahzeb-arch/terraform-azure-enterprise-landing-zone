output "spoke_vnet_ids" {
  description = "Spoke virtual network IDs."
  value       = { for k, v in module.virtual_network : k => v.resource_id }
}

output "subnet_ids" {
  description = "Spoke subnet IDs."
  value       = { for k, v in module.subnet : k => v.id }
}
