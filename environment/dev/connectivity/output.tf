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

output "ddos_protection_plan_ids" {
  description = "DDoS protection plan IDs."
  value       = { for k, m in module.ddos_protection_plan : k => m.id }
}

output "vpn_gateway_ids" {
  description = "VPN gateway IDs."
  value       = { for k, m in module.vpn_gateway : k => m.id }
}

output "expressroute_gateway_ids" {
  description = "ExpressRoute gateway IDs."
  value       = { for k, m in module.expressroute_gateway : k => m.id }
}

output "application_gateway_ids" {
  description = "Application Gateway IDs."
  value       = { for k, m in module.application_gateway : k => m.id }
}

output "frontdoor_profile_ids" {
  description = "Front Door profile IDs."
  value       = { for k, m in module.frontdoor : k => m.profile_id }
}

output "load_balancer_ids" {
  description = "Load balancer IDs."
  value       = { for k, m in module.load_balancer : k => m.id }
}

output "api_management_ids" {
  description = "API Management IDs."
  value       = { for k, m in module.api_management : k => m.id }
}

output "virtual_wan_ids" {
  description = "Virtual WAN IDs."
  value       = { for k, m in module.virtual_wan : k => m.id }
}
