common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

firewall_policies = {
  "afwp_hub" = {
    name = "afwp-qa-hub"
    tags = {
      Environment = "Qa"
    }
  }
}

public_ips = {
  "pip_firewall" = {
    public_ip_name = "pip-qa-firewall"
    tags = {
      Environment = "Qa"
    }
  }
  "pip_bastion" = {
    public_ip_name = "pip-qa-bastion"
    tags = {
      Environment = "Qa"
    }
  }
}

firewalls = {
  "afw_hub" = {
    name                = "afw-qa-hub"
    firewall_policy_key = "afwp_hub"
    public_ip_key       = "pip_firewall"
    tags = {
      Environment = "Qa"
    }
  }
}

bastion_hosts = {
  "bas_hub" = {
    name          = "bas-qa-hub"
    public_ip_key = "pip_bastion"
    tags = {
      Environment = "Qa"
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
