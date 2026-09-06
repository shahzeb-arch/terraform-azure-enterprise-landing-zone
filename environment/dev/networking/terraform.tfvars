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
  "snet-aks" = {
    subnet_name          = "snet-aks"
    resource_group_name  = "rg-dev-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.0.2.0/23"]
  }
  "AzureFirewallSubnet" = {
    subnet_name          = "AzureFirewallSubnet"
    resource_group_name  = "rg-dev-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.0.10.0/26"]
  }
  "AzureBastionSubnet" = {
    subnet_name          = "AzureBastionSubnet"
    resource_group_name  = "rg-dev-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.0.11.0/26"]
  }
  "snet-pe" = {
    subnet_name                       = "snet-pe"
    resource_group_name               = "rg-dev-network"
    virtual_network_name              = "vnet-1"
    address_prefixes                  = ["10.0.12.0/24"]
    private_endpoint_network_policies = "Disabled"
  }
  "GatewaySubnet" = {
    subnet_name          = "GatewaySubnet"
    resource_group_name  = "rg-dev-network"
    virtual_network_name = "vnet-1"
    address_prefixes     = ["10.0.13.0/27"]
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
  # Route AKS subnet traffic via Azure Firewall private IP when connectivity layer is deployed.
  # Set next_hop_in_ip_address to the firewall private IP from connectivity outputs.
  "rt-aks" = {
    name                = "rt-aks"
    resource_group_name = "rg-dev-network"
    location            = "East US"
    subnet_keys         = ["snet-aks"]
    routes = [
      {
        name                   = "default-via-firewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.10.4"
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

public_ips = {
  "pip-nat-1" = {
    public_ip_name      = "pip-dev-nat-1"
    resource_group_name = "rg-dev-network"
    location            = "East US"
    tags = {
      Environment = "Dev"
    }
  }
}

nat_gateway_associations = {
  "nat-gateway-1" = {
    subnet_keys    = ["subnet-1"]
    public_ip_keys = ["pip-nat-1"]
  }
}

private_dns_zones = {
  "pdns-kv" = {
    private_dns_zone_name = "privatelink.vaultcore.azure.net"
    resource_group_name   = "rg-dev-network"
    tags = {
      Environment = "Dev"
    }
  }
  "pdns-blob" = {
    private_dns_zone_name = "privatelink.blob.core.windows.net"
    resource_group_name   = "rg-dev-network"
    tags = {
      Environment = "Dev"
    }
  }
}

private_dns_vnet_links = {
  "link-kv-hub" = {
    private_dns_zone_link_name = "link-kv-hub"
    resource_group_name        = "rg-dev-network"
    private_dns_zone_key       = "pdns-kv"
    virtual_network_key        = "vnet_1"
    tags = {
      Environment = "Dev"
    }
  }
  "link-blob-hub" = {
    private_dns_zone_link_name = "link-blob-hub"
    resource_group_name        = "rg-dev-network"
    private_dns_zone_key       = "pdns-blob"
    virtual_network_key        = "vnet_1"
    tags = {
      Environment = "Dev"
    }
  }
}
