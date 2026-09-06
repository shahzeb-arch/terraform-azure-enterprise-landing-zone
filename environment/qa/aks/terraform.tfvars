common_tags = {
  Owner   = "Shahzeb"
  Project = "Terraform ELZ"
}

# AKS resource group (separate from networking RG)
rgs = {
  "rg_aks" = {
    resource_group_name     = "rg-qa-aks"
    resource_group_location = "East US"
    tags = {
      Environment = "Qa"
      Layer       = "aks"
    }
  }
}

# Subnet must exist in networking layer first (see environment/dev/networking/terraform.tfvars → snet-aks)
subnet_lookups = {
  "snet-aks" = {
    subnet_name          = "snet-aks"
    virtual_network_name = "vnet-1"
    resource_group_name  = "rg-qa-network"
  }
}

aks_clusters = {
  "aks-dev" = {
    cluster_name       = "aks-qa-private"
    location           = "East US"
    resource_group_key = "rg_aks"
    dns_prefix         = "aksdevprivate"

    # Private cluster (production pattern)
    private_cluster_enabled = true
    private_dns_zone_id     = null # null = Azure-managed private DNS

    # Dev: keep local account enabled until Entra admin group is configured
    local_account_disabled = false

    subnet_lookup_key = "snet-aks"

    system_node_pool = {
      vm_size             = "Standard_D2s_v5"
      node_count          = 1
      enable_auto_scaling = false
      zones               = ["1"]
    }

    network_profile = {
      network_plugin      = "azure"
      network_plugin_mode = "overlay"
      network_policy      = "azure"
      # Dev: loadBalancer outbound (no firewall UDR required). Prod: userDefinedRouting
      outbound_type  = "loadBalancer"
      service_cidr   = "10.240.0.0/16"
      dns_service_ip = "10.240.0.10"
    }

    rbac = {
      azure_rbac_enabled     = true
      admin_group_object_ids = [] # TODO: add Entra ID group object ID for prod
    }

    tags = {
      Environment = "Qa"
    }
  }
}

aks_nodepools = {
  "app" = {
    name                 = "app"
    cluster_key          = "aks-dev"
    vm_size              = "Standard_D2s_v5"
    subnet_lookup_key    = "snet-aks"
    node_count           = 1
    auto_scaling_enabled = false
    zones                = ["1"]
    node_labels = {
      workload = "app"
    }
    node_taints = []
    tags = {
      Environment = "Qa"
      Pool        = "app"
    }
  }
}
