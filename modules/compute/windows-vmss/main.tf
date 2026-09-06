resource "azurerm_windows_virtual_machine_scale_set" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instances
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  overprovision              = var.overprovision
  upgrade_mode               = var.upgrade_mode
  single_placement_group     = var.single_placement_group
  encryption_at_host_enabled = var.encryption_at_host_enabled
  secure_boot_enabled        = var.secure_boot_enabled
  vtpm_enabled               = var.vtpm_enabled
  zones                      = var.zones
  tags                       = var.tags

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  network_interface {
    name                          = var.network_interface.name
    primary                       = true
    enable_accelerated_networking = var.network_interface.enable_accelerated_networking
    network_security_group_id     = var.network_interface.network_security_group_id

    ip_configuration {
      name                                   = var.network_interface.ip_configuration.name
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.network_interface.ip_configuration.load_balancer_backend_address_pool_ids
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics != null ? [var.boot_diagnostics] : []
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }
}
