common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

firewall_policies = {
  "afwp_hub" = {
    name = "afwp-dev-hub"
    tags = {
      Environment = "Dev"
    }
  }
}

public_ips = {
  "pip_firewall" = {
    public_ip_name = "pip-dev-firewall"
    tags = {
      Environment = "Dev"
    }
  }
  "pip_bastion" = {
    public_ip_name = "pip-dev-bastion"
    tags = {
      Environment = "Dev"
    }
  }
}

firewalls = {
  "afw_hub" = {
    name                = "afw-dev-hub"
    firewall_policy_key = "afwp_hub"
    public_ip_key       = "pip_firewall"
    tags = {
      Environment = "Dev"
    }
  }
}

bastion_hosts = {
  "bas_hub" = {
    name          = "bas-dev-hub"
    public_ip_key = "pip_bastion"
    tags = {
      Environment = "Dev"
    }
  }
}

ddos_protection_plans = {
  "ddos_hub" = {
    name = "ddos-dev-hub"
    tags = {
      Environment = "Dev"
    }
  }
}

# Uncomment when hybrid connectivity is required (add pip_vpn to public_ips first).
# vpn_gateways = {
#   "vpng_hub" = {
#     name          = "vpng-dev-hub"
#     public_ip_key = "pip_vpn"
#     ip_configuration = { name = "vnetGatewayConfig" }
#   }
# }

# Uncomment and set remote VNet ID when a spoke is provisioned.
# vnet_peerings = {
#   "hub_to_spoke" = {
#     name                      = "peer-hub-to-spoke"
#     remote_virtual_network_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/vnet-spoke"
#     allow_forwarded_traffic   = true
#   }
# }
