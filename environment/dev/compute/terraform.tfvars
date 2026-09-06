common_tags = {
  "Owner"   = "Shahzeb"
  "Project" = "Terraform ELZ"
}

# Subnets to resolve from the networking layer (must already exist).
subnet_lookups = {
  "subnet-1" = {
    subnet_name          = "subnet-1"
    virtual_network_name = "vnet-1"
    resource_group_name  = "rg-dev-network"
  }
}

network_interfaces = {
  "nic-linux-1" = {
    name                    = "nic-linux-1"
    resource_group_name     = "rg-dev-network"
    location                = "East US"
    subnet_key              = "subnet-1"
    internal_dns_name_label = "nic-linux-1"
    ip_configuration = {
      name                          = "ipconfig-linux-1"
      private_ip_address_allocation = "Dynamic"
    }
    tags = {
      Environment = "Dev"
    }
  }

  "nic-windows-1" = {
    name                    = "nic-windows-1"
    resource_group_name     = "rg-dev-network"
    location                = "East US"
    subnet_key              = "subnet-1"
    internal_dns_name_label = "nic-windows-1"
    ip_configuration = {
      name                          = "ipconfig-windows-1"
      private_ip_address_allocation = "Dynamic"
    }
    tags = {
      Environment = "Dev"
    }
  }
}

linux_virtual_machines = {
  "linux-vm-1" = {
    name                   = "linux-vm-1"
    resource_group_name    = "rg-dev-network"
    location               = "East US"
    size                   = "Standard_B1s"
    admin_username         = "azureuser"
    admin_ssh_public_key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrQn/BwK6k1gaNqFPD/MG4kCUghBV998GYrKRd76tYH pro@MacBookPro.lan"
    network_interface_keys = ["nic-linux-1"]
    tags = {
      Environment = "Dev"
    }
  }
}

windows_virtual_machines = {
  "windows-vm-1" = {
    name                = "windows-vm-1"
    resource_group_name = "rg-dev-network"
    location            = "East US"
    size                = "Standard_B2s"
    admin_username      = "azureuser"
    # NOTE: never commit real passwords. Pass via TF_VAR / Key Vault in real envs.
    admin_password         = "P@ssw0rd1234!"
    network_interface_keys = ["nic-windows-1"]
    tags = {
      Environment = "Dev"
    }
  }
}

linux_vmss = {
  "linux-vmss-1" = {
    name                 = "linux-vmss-1"
    resource_group_name  = "rg-dev-network"
    location             = "East US"
    sku                  = "Standard_B1ms"
    instances            = 1
    admin_username       = "azureuser"
    admin_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrQn/BwK6k1gaNqFPD/MG4kCUghBV998GYrKRd76tYH pro@MacBookPro.lan"
    subnet_key           = "subnet-1"
    network_interface = {
      name                          = "vmss-nic"
      enable_accelerated_networking = false
      ip_configuration = {
        name                                         = "vmss-ipconfig"
        application_gateway_backend_address_pool_ids = []
        load_balancer_backend_address_pool_ids       = []
        load_balancer_inbound_nat_rules_ids          = []
      }
    }
    tags = {
      Environment = "Dev"
    }
  }
}
