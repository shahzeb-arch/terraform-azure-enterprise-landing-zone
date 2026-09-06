common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

firewall_policies = {
  "afwp_hub" = {
    name = "afwp-prod-hub"
    tags = {
      Environment = "Prod"
    }
  }
}

public_ips = {
  "pip_firewall" = {
    public_ip_name = "pip-prod-firewall"
    tags = {
      Environment = "Prod"
    }
  }
  "pip_bastion" = {
    public_ip_name = "pip-prod-bastion"
    tags = {
      Environment = "Prod"
    }
  }
}

firewalls = {
  "afw_hub" = {
    name                = "afw-prod-hub"
    firewall_policy_key = "afwp_hub"
    public_ip_key       = "pip_firewall"
    tags = {
      Environment = "Prod"
    }
  }
}

bastion_hosts = {
  "bas_hub" = {
    name          = "bas-prod-hub"
    public_ip_key = "pip_bastion"
    tags = {
      Environment = "Prod"
    }
  }
}

# Uncomment and set remote VNet ID when a spoke is provisioned.
# vnet_peerings = {
#   "hub_to_spoke" = {
#     name                      = "peer-hub-to-spoke"
#     remote_virtual_network_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/vnet-spoke"
#     allow_forwarded_traffic   = true
#   }
# }
