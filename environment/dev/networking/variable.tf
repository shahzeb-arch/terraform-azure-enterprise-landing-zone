variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = map(string)
  }))
  description = "Resource group configuration"
}
variable "virtual_networks" {
  type = map(object({
    virtual_network_name = string
    resource_group_name  = string
    location             = string
    address_space        = list(string)
    tags                 = map(string)
  }))
}

variable "subnets" {
  type = map(object({
    subnet_name          = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
}

variable "network_security_groups" {
  description = "Network security group configurations."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    subnet_keys         = optional(list(string), [])
    security_rules = optional(list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      description                                = optional(string)
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "route_tables" {
  description = "Route table configurations."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    bgp_route_propagation_enabled = optional(bool, true)
    subnet_keys                   = optional(list(string), [])
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
    tags = optional(map(string), {})
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

variable "nat_gateway" {
  type = map(object({
    nat_gateway_name = string
    location = string
    resource_group_name = string
    sku_name = string
    idle_timeout_in_minutes = optional(number, 10)
    zones = optional(list(string), ["1"])
    tags = optional(map(string), {})
  }))
}
