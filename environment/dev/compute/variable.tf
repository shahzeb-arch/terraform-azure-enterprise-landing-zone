variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "subnet_lookups" {
  description = "Subnets (from the networking layer) to resolve by name for placement."
  type = map(object({
    subnet_name          = string
    virtual_network_name = string
    resource_group_name  = string
  }))
  default = {}
}

variable "network_interfaces" {
  description = "Network interface configurations."
  type = map(object({
    name                           = string
    resource_group_name            = string
    location                       = string
    subnet_key                     = string
    accelerated_networking_enabled = optional(bool, false)
    dns_servers                    = optional(list(string), [])
    internal_dns_name_label        = optional(string)
    ip_forwarding_enabled          = optional(bool, false)
    ip_configuration = object({
      name                          = string
      private_ip_address_allocation = optional(string, "Dynamic")
      private_ip_address            = optional(string)
      public_ip_address_id          = optional(string)
    })
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "linux_virtual_machines" {
  description = "Linux virtual machine configurations."
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    size                       = string
    admin_username             = string
    admin_ssh_public_key       = string
    network_interface_keys     = list(string)
    encryption_at_host_enabled = optional(bool, true)
    patch_assessment_mode      = optional(string, "ImageDefault")
    patch_mode                 = optional(string, "ImageDefault")
    secure_boot_enabled        = optional(bool, true)
    vtpm_enabled               = optional(bool, true)
    zone                       = optional(string)
    os_disk = optional(object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
      }), {
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
    })
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
      }), {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    })
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    additional_capabilities = optional(object({
      ultra_ssd_enabled   = optional(bool, false)
      hibernation_enabled = optional(bool, false)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "windows_virtual_machines" {
  description = "Windows virtual machine configurations."
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    size                       = string
    admin_username             = string
    admin_password             = string
    network_interface_keys     = list(string)
    encryption_at_host_enabled = optional(bool, true)
    patch_assessment_mode      = optional(string, "ImageDefault")
    patch_mode                 = optional(string, "AutomaticByOS")
    provision_vm_agent         = optional(bool, true)
    secure_boot_enabled        = optional(bool, true)
    vtpm_enabled               = optional(bool, true)
    zone                       = optional(string)
    os_disk = optional(object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
      }), {
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
    })
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
      }), {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    })
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "linux_vmss" {
  description = "Linux virtual machine scale set configurations."
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    sku                             = string
    instances                       = number
    admin_username                  = string
    admin_ssh_public_key            = string
    subnet_key                      = string
    disable_password_authentication = optional(bool, true)
    encryption_at_host_enabled      = optional(bool, true)
    overprovision                   = optional(bool, false)
    provision_vm_agent              = optional(bool, true)
    secure_boot_enabled             = optional(bool, true)
    single_placement_group          = optional(bool, false)
    upgrade_mode                    = optional(string, "Manual")
    vtpm_enabled                    = optional(bool, true)
    zones                           = optional(list(string), [])
    os_disk = optional(object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
      }), {
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
    })
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
      }), {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    })
    network_interface = object({
      name                          = string
      enable_accelerated_networking = optional(bool, false)
      network_security_group_id     = optional(string)
      ip_configuration = object({
        name                                         = string
        application_gateway_backend_address_pool_ids = optional(list(string), [])
        load_balancer_backend_address_pool_ids       = optional(list(string), [])
        load_balancer_inbound_nat_rules_ids          = optional(list(string), [])
      })
    })
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "availability_sets" {
  description = "Availability sets for VM high availability."
  type = map(object({
    name                         = string
    location                     = string
    resource_group_name          = string
    platform_fault_domain_count  = optional(number, 2)
    platform_update_domain_count = optional(number, 5)
    managed                      = optional(bool, true)
    tags                         = optional(map(string), {})
  }))
  default = {}
}

variable "windows_vmss" {
  description = "Windows virtual machine scale set configurations."
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    sku                        = string
    instances                  = optional(number, 2)
    admin_username             = string
    admin_password             = string
    subnet_key                 = string
    overprovision              = optional(bool, false)
    upgrade_mode               = optional(string, "Rolling")
    single_placement_group     = optional(bool, true)
    encryption_at_host_enabled = optional(bool, true)
    secure_boot_enabled        = optional(bool, true)
    vtpm_enabled               = optional(bool, true)
    zones                      = optional(list(string), ["1", "2", "3"])
    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Premium_LRS")
      disk_size_gb         = optional(number)
    }), {})
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = optional(string, "latest")
    })
    network_interface = object({
      name                          = optional(string, "primary")
      enable_accelerated_networking = optional(bool, true)
      network_security_group_id     = optional(string)
      ip_configuration = object({
        name                                   = optional(string, "internal")
        load_balancer_backend_address_pool_ids = optional(list(string), [])
      })
    })
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    boot_diagnostics = optional(object({
      storage_account_uri = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "service_plans" {
  description = "App Service plan definitions."
  type = map(object({
    name                   = string
    location               = string
    resource_group_name    = string
    os_type                = optional(string, "Linux")
    sku_name               = optional(string, "P1v3")
    worker_count           = optional(number, 1)
    zone_balancing_enabled = optional(bool, false)
    tags                   = optional(map(string), {})
  }))
  default = {}
}

variable "app_services" {
  description = "Linux Web App definitions."
  type = map(object({
    name                    = string
    location                = string
    resource_group_name     = string
    service_plan_key        = string
    https_only              = optional(bool, true)
    client_affinity_enabled = optional(bool, false)
    app_settings            = optional(map(string), {})
    site_config             = optional(any, {})
    identity                = optional(any)
    auth_settings_v2        = optional(any)
    connection_strings      = optional(list(any), [])
    sticky_settings         = optional(any)
    tags                    = optional(map(string), {})
  }))
  default = {}
}

variable "function_apps" {
  description = "Linux Function App definitions."
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    service_plan_key           = string
    storage_account_name       = string
    storage_account_access_key = string
    https_only                 = optional(bool, true)
    app_settings               = optional(map(string), {})
    site_config                = optional(any, {})
    identity                   = optional(any)
    connection_strings         = optional(list(any), [])
    tags                       = optional(map(string), {})
  }))
  default = {}
}
