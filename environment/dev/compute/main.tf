# Dev / compute layer.
# Creates network interfaces, virtual machines and scale sets. Subnet IDs are
# resolved from the networking layer via data sources (see data.tf).
module "network_interface" {
  for_each = var.network_interfaces
  source   = "../../../modules/compute/networkInterface"

  name                           = each.value.name
  resource_group_name            = each.value.resource_group_name
  location                       = each.value.location
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  dns_servers                    = each.value.dns_servers
  internal_dns_name_label        = each.value.internal_dns_name_label
  ip_forwarding_enabled          = each.value.ip_forwarding_enabled
  ip_configuration = {
    name                          = each.value.ip_configuration.name
    subnet_id                     = data.azurerm_subnet.this[each.value.subnet_key].id
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    private_ip_address            = each.value.ip_configuration.private_ip_address
    public_ip_address_id          = each.value.ip_configuration.public_ip_address_id
  }
  tags = merge(var.common_tags, each.value.tags)
}

module "linux_virtual_machine" {
  for_each = var.linux_virtual_machines
  source   = "../../../modules/compute/linux_virtualMachine"

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
  source   = "../../../modules/compute/windows_virtualMachine"

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
  source   = "../../../modules/compute/linux_vmss"

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  sku                             = each.value.sku
  instances                       = each.value.instances
  admin_username                  = each.value.admin_username
  admin_ssh_public_key            = each.value.admin_ssh_public_key
  subnet_id                       = data.azurerm_subnet.this[each.value.subnet_key].id
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
}
