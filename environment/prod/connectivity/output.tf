output "hub_vnet_id" {
  description = "Hub virtual network ID."
  value       = data.azurerm_virtual_network.hub.id
}

output "firewall_policy_ids" {
  description = "Firewall policy IDs."
  value       = { for k, m in module.firewall_policy : k => m.id }
}

output "firewall_ids" {
  description = "Azure Firewall IDs."
  value       = { for k, m in module.firewall : k => m.id }
}

output "firewall_private_ip_addresses" {
  description = "Azure Firewall private IPs."
  value       = { for k, m in module.firewall : k => m.private_ip_address }
}

output "bastion_ids" {
  description = "Bastion host IDs."
  value       = { for k, m in module.bastion : k => m.id }
}

output "vnet_peering_ids" {
  description = "VNet peering IDs."
  value       = { for k, m in module.vnet_peering : k => m.id }
}

output "public_ip_ids" {
  description = "Public IP IDs."
  value       = { for k, m in module.public_ip : k => m.id }
}
