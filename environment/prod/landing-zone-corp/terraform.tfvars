common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

rgs = {
  "rg_corp" = {
    resource_group_name     = "rg-prod-corp"
    resource_group_location = "East US"
    tags = {
      Environment = "Prod"
      LandingZone = "Corp"
    }
  }
}

virtual_networks = {
  "vnet_corp" = {
    virtual_network_name = "vnet-corp-prod"
    resource_group_key   = "rg_corp"
    location             = "East US"
    address_space        = ["10.2.64.0/18"]
    tags = {
      Environment = "Prod"
      LandingZone = "Corp"
    }
  }
}

subnets = {
  "snet_app" = {
    subnet_name          = "snet-app"
    resource_group_key   = "rg_corp"
    virtual_network_name = "vnet-corp-prod"
    address_prefixes     = ["10.2.64.0/24"]
  }
  "snet_data" = {
    subnet_name          = "snet-data"
    resource_group_key   = "rg_corp"
    virtual_network_name = "vnet-corp-prod"
    address_prefixes     = ["10.2.65.0/24"]
  }
}

vnet_peerings = {
  "corp" = {
    resource_group_key = "rg_corp"
    spoke_vnet_key     = "vnet_corp"
    hub_peering_name   = "peer-hub-to-corp"
    spoke_peering_name = "peer-corp-to-hub"
  }
}
