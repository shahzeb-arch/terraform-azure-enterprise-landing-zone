common_tags = {
  "Owner"   = "Shahzeb"
  "Project" = "Terraform ELZ"
}

rgs = {
  "resource_group_1" = {
    resource_group_name     = "rg-qa-network"
    resource_group_location = "East US"
    tags = {
      Environment = "Qa"
    }
  }
}

virtual_networks = {
  "vnet_1" = {
    virtual_network_name = "vnet-1"
    location             = "East US"
    resource_group_name  = "rg-qa-network"
    address_space        = ["10.1.0.0/16"]
    tags = {
      Environment = "Qa"
    }
  }
}

subnets = {
  "subnet-1" = {
    subnet_name          = "subnet-1"
    resource_group_name  = "rg-qa-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.1.1.0/24"]
  }
  "snet-aks" = {
    subnet_name          = "snet-aks"
    resource_group_name  = "rg-qa-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.1.2.0/23"]
  }
  "AzureFirewallSubnet" = {
    subnet_name          = "AzureFirewallSubnet"
    resource_group_name  = "rg-qa-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.1.10.0/26"]
  }
  "AzureBastionSubnet" = {
    subnet_name          = "AzureBastionSubnet"
    resource_group_name  = "rg-qa-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.1.11.0/26"]
  }
  "snet-pe" = {
    subnet_name                       = "snet-pe"
    resource_group_name               = "rg-qa-network"
    virtual_network_name              = "vnet-1"
    address_prefixes                  = ["10.1.12.0/24"]
    private_endpoint_network_policies = "Disabled"
  }
  "GatewaySubnet" = {
    subnet_name          = "GatewaySubnet"
    resource_group_name  = "rg-qa-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.1.13.0/27"]
  }
}

network_security_groups = {
  "nsg-1" = {
    name                = "nsg-1"
    resource_group_name = "rg-qa-network"
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
        source_address_prefix      = "10.1.0.0/8"
        destination_address_prefix = "*"
        description                = "Allow SSH only from corp range (avoid 0.0.0.0/0 in prod)"
      }
    ]
    tags = {
      Environment = "Qa"
    }
  }
}

route_tables = {
  "rt-1" = {
    name                = "rt-1"
    resource_group_name = "rg-qa-network"
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
      Environment = "Qa"
    }
  }
  # Route AKS subnet traffic via Azure Firewall private IP when connectivity layer is deployed.
  # Set next_hop_in_ip_address to the firewall private IP from connectivity outputs.
  "rt-aks" = {
    name                = "rt-aks"
    resource_group_name = "rg-qa-network"
    location            = "East US"
    subnet_keys         = ["snet-aks"]
    routes = [
      {
        name                   = "default-via-firewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.1.10.4"
      }
    ]
    tags = {
      Environment = "Qa"
    }
  }
}

nat_gateway = {
  "nat-gateway-1" = {
    nat_gateway_name        = "nat-gateway-1"
    resource_group_name     = "rg-qa-network"
    location                = "East US"
    sku_name                = "Standard"
    idle_timeout_in_minutes = 10
    zones                   = ["1"]
    tags = {
      Environment = "Qa"
    }
  }
}
