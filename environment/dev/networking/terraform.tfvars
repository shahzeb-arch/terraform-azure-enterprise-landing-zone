common_tags = {
  "Owner"   = "Shahzeb"
  "Project" = "Terraform ELZ"
}

rgs = {
  "resource_group_1" = {
    resource_group_name     = "rg-dev-network"
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
    resource_group_name  = "rg-dev-network"
    address_space        = ["10.0.0.0/16"]
    tags = {
      Environment = "Dev"
    }
  }
}

subnets = {
  "subnet-1" = {
    subnet_name          = "subnet-1"
    resource_group_name  = "rg-dev-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.0.1.0/24"]
  }
}

network_security_groups = {
  "nsg-1" = {
    name                = "nsg-1"
    resource_group_name = "rg-dev-network"
    location            = "East US"
    subnet_keys         = ["subnet-1"]
    security_rules = [
      {
        name                       = "allow_ssh_from_corp"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
        description                = "Allow SSH only from corp range (avoid 0.0.0.0/0 in prod)"
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
    resource_group_name = "rg-dev-network"
    location            = "East US"
    subnet_keys         = ["subnet-1"]
    routes = [
      {
        name           = "default-route"
        address_prefix = "0.0.0.0/0"
        next_hop_type  = "Internet"
      }
    ]
    tags = {
      Environment = "Dev"
    }
  }
}

nat_gateway = {
  "nat-gateway-1" = {
    nat_gateway_name        = "nat-gateway-1"
    resource_group_name     = "rg-dev-network"
    location                = "East US"
    sku_name                = "Standard"
    idle_timeout_in_minutes = 10
    zones                   = ["1"]
    tags = {
      Environment = "Dev"
    }
  }
}
