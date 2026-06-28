common_tags = {
  "Owner"   = "Shahzeb"
  "Project" = "Terraform ELZ"
}
rgs = {
  "resource_group_1" = {
    resource_group_name     = "rg-1"
    resource_group_location = "East US"
    tags = {
      Environment = "Dev"
    }
  }
}

virtual_networks = {
  "vnet_1" = {
    virtual_network_name = "vnet-1"
    location             = "East US"
    resource_group_name  = "rg-1"
    address_space        = ["10.0.0.0/16"]
    tags = {
      Environment = "Dev"
    }
  }
}

subnets = {
  "subnet-1" = {
    subnet_name          = "subnet-1"
    resource_group_name  = "rg-1"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.0.1.0/24"]
  }
}

network_security_groups = {
  "nsg-1" = {
    name                = "nsg-1"
    resource_group_name = "rg-1"
    location            = "East US"
    subnet_keys         = ["subnet-1"]
    security_rules = [
      {
        name                       = "allow_ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "0.0.0.0/0"
        destination_address_prefix = "*"
        description                = "Allow SSH from internet"
      }
    ]
    tags = {
      Environment = "Dev"
    }
  }
}

route_tables = {
  "rt-1" = {
    name                = "rt-1"
    resource_group_name = "rg-1"
    location            = "East US"
    subnet_keys         = ["subnet-1"]
    routes = [
      {
        name                   = "default-route"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "Internet"
      }
    ]
    tags = {
      Environment = "Dev"
    }
  }
}

network_interfaces = {
  "nic-linux-1" = {
    name                           = "nic-linux-1"
    resource_group_name            = "rg-1"
    location                       = "East US"
    subnet_key                     = "subnet-1"
    internal_dns_name_label        = "nic-linux-1"
    ip_configuration = {
      name                          = "ipconfig-linux-1"
      private_ip_address_allocation = "Dynamic"
    }
    tags = {
      Environment = "Dev"
    }
  }

  "nic-windows-1" = {
    name                           = "nic-windows-1"
    resource_group_name            = "rg-1"
    location                       = "East US"
    subnet_key                     = "subnet-1"
    internal_dns_name_label        = "nic-windows-1"
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
    name                  = "linux-vm-1"
    resource_group_name   = "rg-1"
    location              = "East US"
    size                  = "Standard_B1s"
    admin_username        = "azureuser"
    admin_ssh_public_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrQn/BwK6k1gaNqFPD/MG4kCUghBV998GYrKRd76tYH pro@MacBookPro.lan"
    network_interface_keys = ["nic-linux-1"]
    tags = {
      Environment = "Dev"
    }
  }
}

windows_virtual_machines = {
  "windows-vm-1" = {
    name                  = "windows-vm-1"
    resource_group_name   = "rg-1"
    location              = "East US"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
    admin_password        = "P@ssw0rd1234!"
    network_interface_keys = ["nic-windows-1"]
    tags = {
      Environment = "Dev"
    }
  }
}

linux_vmss = {
  "linux-vmss-1" = {
    name                            = "linux-vmss-1"
    resource_group_name             = "rg-1"
    location                        = "East US"
    sku                             = "Standard_B1ms"
    instances                       = 1
    admin_username                  = "azureuser"
    admin_ssh_public_key            = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrQn/BwK6k1gaNqFPD/MG4kCUghBV998GYrKRd76tYH pro@MacBookPro.lan"
    subnet_key                      = "subnet-1"
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

nat_gateway = {
  "nat-gateway-1" = {
    nat_gateway_name = "nat-gateway-1"
    resource_group_name = "rg-1"
    location            = "East US"
    sku_name = "Standard"
    idle_timeout_in_minutes = 10
    zones = ["1"]
    tags = {
      Environment = "Dev"
    }
  }
}
