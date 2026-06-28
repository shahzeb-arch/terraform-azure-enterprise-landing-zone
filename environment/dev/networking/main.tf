# This file defines the main Terraform configuration for the networking environment in the development stage.
# resource groups, virtual networks, and subnets are created based on the variables defined in variable.tf and the values provided in terraform.tfvars.
# The configuration uses modules for resource groups, virtual networks, and subnets to promote reusability and maintainability.
# The output.tf file defines outputs for resource group IDs, virtual network IDs, and virtual network names for use in other parts of the Terraform configuration or for reference after deployment.
module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "virtual_network" {
  for_each             = var.virtual_networks
  source               = "../../../modules/network/virtualNetwork"
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
  location             = each.value.location
  address_space        = each.value.address_space
  tags                 = merge(var.common_tags, each.value.tags)

  depends_on = [module.resource_group]
}

module "subnet" {
  for_each             = var.subnets
  source               = "../../../modules/network/subnet"
  subnet_name          = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

  depends_on = [module.virtual_network]
}

module "network_security_group" {
  for_each = var.network_security_groups
  source   = "../../../modules/network/networkSecurityGroup"

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  security_rules      = each.value.security_rules
  subnet_ids          = [for subnet_key in each.value.subnet_keys : module.subnet[subnet_key].id]
  tags                = merge(var.common_tags, each.value.tags)

  depends_on = [module.subnet]
}

module "route_table" {
  for_each = var.route_tables
  source   = "../../../modules/network/routeTable"

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
  routes                        = each.value.routes
  subnet_ids                    = [for subnet_key in each.value.subnet_keys : module.subnet[subnet_key].id]
  tags                          = merge(var.common_tags, each.value.tags)

  depends_on = [module.subnet]
}

module "network_interface" {
  for_each = var.network_interfaces
  source   = "../../../modules/network/networkInterface"

  name                           = each.value.name
  resource_group_name            = each.value.resource_group_name
  location                       = each.value.location
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  dns_servers                    = each.value.dns_servers
  internal_dns_name_label        = each.value.internal_dns_name_label
  ip_forwarding_enabled          = each.value.ip_forwarding_enabled
  ip_configuration = {
    name                          = each.value.ip_configuration.name
    subnet_id                     = module.subnet[each.value.subnet_key].id
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    private_ip_address            = each.value.ip_configuration.private_ip_address
    public_ip_address_id          = each.value.ip_configuration.public_ip_address_id
  }
  tags = merge(var.common_tags, each.value.tags)

  depends_on = [
    module.network_security_group,
    module.route_table
  ]
}

module "linux_virtual_machine" {
  for_each = var.linux_virtual_machines
  source   = "../../../modules/network/linux_virtualMachine"

  name                       = each.value.name
  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location
  size                       = each.value.size
  admin_username             = each.value.admin_username
  admin_ssh_public_key       = each.value.admin_ssh_public_key
  network_interface_ids      = [for nic_key in each.value.network_interface_keys : module.network_interface[nic_key].id]
  encryption_at_host_enabled = each.value.encryption_at_host_enabled
  patch_assessment_mode      = each.value.patch_assessment_mode
  patch_mode                 = each.value.patch_mode
  secure_boot_enabled        = each.value.secure_boot_enabled
  vtpm_enabled               = each.value.vtpm_enabled
  zone                       = each.value.zone
  os_disk                    = each.value.os_disk
  source_image_reference     = each.value.source_image_reference
  identity                   = each.value.identity
  boot_diagnostics           = each.value.boot_diagnostics
  additional_capabilities    = each.value.additional_capabilities
  tags                       = merge(var.common_tags, each.value.tags)

  depends_on = [module.network_interface]
}

module "windows_virtual_machine" {
  for_each = var.windows_virtual_machines
  source   = "../../../modules/network/windows_virtualMachine"

  name                       = each.value.name
  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location
  size                       = each.value.size
  admin_username             = each.value.admin_username
  admin_password             = each.value.admin_password
  network_interface_ids      = [for nic_key in each.value.network_interface_keys : module.network_interface[nic_key].id]
  encryption_at_host_enabled = each.value.encryption_at_host_enabled
  patch_assessment_mode      = each.value.patch_assessment_mode
  patch_mode                 = each.value.patch_mode
  provision_vm_agent         = each.value.provision_vm_agent
  secure_boot_enabled        = each.value.secure_boot_enabled
  vtpm_enabled               = each.value.vtpm_enabled
  zone                       = each.value.zone
  os_disk                    = each.value.os_disk
  source_image_reference     = each.value.source_image_reference
  identity                   = each.value.identity
  boot_diagnostics           = each.value.boot_diagnostics
  tags                       = merge(var.common_tags, each.value.tags)

  depends_on = [module.network_interface]
}

module "linux_vmss" {
  for_each = var.linux_vmss
  source   = "../../../modules/network/linux_vmss"

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  sku                             = each.value.sku
  instances                       = each.value.instances
  admin_username                  = each.value.admin_username
  admin_ssh_public_key            = each.value.admin_ssh_public_key
  subnet_id                       = module.subnet[each.value.subnet_key].id
  disable_password_authentication = each.value.disable_password_authentication
  encryption_at_host_enabled      = each.value.encryption_at_host_enabled
  overprovision                   = each.value.overprovision
  provision_vm_agent              = each.value.provision_vm_agent
  secure_boot_enabled             = each.value.secure_boot_enabled
  single_placement_group          = each.value.single_placement_group
  upgrade_mode                    = each.value.upgrade_mode
  vtpm_enabled                    = each.value.vtpm_enabled
  zones                           = each.value.zones
  os_disk                         = each.value.os_disk
  source_image_reference          = each.value.source_image_reference
  network_interface               = each.value.network_interface
  identity                        = each.value.identity
  boot_diagnostics                = each.value.boot_diagnostics
  tags                            = merge(var.common_tags, each.value.tags)

  depends_on = [module.subnet]
}

module "nat_gateway" {
  for_each = var.nat_gateway
  source = "../../../modules/network/nat_gateway"
  nat_gateway_name = each.value.nat_gateway_name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name = each.value.sku_name
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  zones = each.value.zones
  tags = merge(var.common_tags, each.value.tags)
}
