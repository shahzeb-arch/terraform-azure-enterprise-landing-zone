resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = var.network_interface_ids

  encryption_at_host_enabled = var.encryption_at_host_enabled
  patch_assessment_mode      = var.patch_assessment_mode
  patch_mode                 = var.patch_mode
  provision_vm_agent         = var.provision_vm_agent
  secure_boot_enabled        = var.secure_boot_enabled
  vtpm_enabled               = var.vtpm_enabled
  zone                       = var.zone

  tags = var.tags

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

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics == null ? [] : [var.boot_diagnostics]
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }
}
