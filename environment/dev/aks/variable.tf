variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all AKS resources."
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "rgs" {
  description = "Resource groups for the AKS layer."
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    tags                    = optional(map(string), {})
  }))
}

variable "subnet_lookups" {
  description = "Subnets from the networking layer (must exist before apply)."
  type = map(object({
    subnet_name          = string
    virtual_network_name = string
    resource_group_name  = string
  }))
}

variable "aks_clusters" {
  description = "Private AKS cluster definitions."
  type = map(object({
    cluster_name                        = string
    location                            = string
    resource_group_key                  = string
    dns_prefix                          = string
    kubernetes_version                  = optional(string)
    sku_tier                            = optional(string, "Standard")
    private_cluster_enabled             = optional(bool, true)
    private_dns_zone_id                 = optional(string)
    private_cluster_public_fqdn_enabled = optional(bool, false)
    local_account_disabled              = optional(bool, false)
    azure_policy_enabled                = optional(bool, true)
    oidc_issuer_enabled                 = optional(bool, true)
    workload_identity_enabled           = optional(bool, true)
    subnet_lookup_key                   = string
    system_node_pool = object({
      name                = optional(string, "system")
      vm_size             = string
      node_count          = optional(number, 1)
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number, 1)
      max_count           = optional(number, 3)
      os_disk_size_gb     = optional(number, 128)
      zones               = optional(list(string), ["1"])
      max_pods            = optional(number, 110)
    })
    network_profile = object({
      network_plugin      = optional(string, "azure")
      network_plugin_mode = optional(string, "overlay")
      network_policy      = optional(string, "azure")
      outbound_type       = optional(string, "loadBalancer")
      load_balancer_sku   = optional(string, "standard")
      service_cidr        = string
      dns_service_ip      = string
    })
    rbac = optional(object({
      azure_rbac_enabled     = optional(bool, true)
      admin_group_object_ids = optional(list(string), [])
      tenant_id              = optional(string)
    }), {})
    tags = optional(map(string), {})
  }))
}

variable "aks_nodepools" {
  description = "Additional worker node pools."
  type = map(object({
    name                 = string
    cluster_key          = string
    vm_size              = string
    subnet_lookup_key    = string
    mode                 = optional(string, "User")
    node_count           = optional(number, 1)
    auto_scaling_enabled = optional(bool, false)
    min_count            = optional(number, 1)
    max_count            = optional(number, 5)
    os_disk_size_gb      = optional(number, 128)
    zones                = optional(list(string), ["1"])
    max_pods             = optional(number, 110)
    node_labels          = optional(map(string), {})
    node_taints          = optional(list(string), [])
    tags                 = optional(map(string), {})
  }))
  default = {}
}

variable "aks_extensions" {
  description = "AKS cluster extensions (Azure Monitor, Defender, etc.)."
  type = map(object({
    name                             = string
    cluster_key                      = string
    extension_type                   = string
    target_namespace                 = optional(string)
    release_train                    = optional(string, "stable")
    release_namespace                = optional(string)
    configuration_settings           = optional(map(string), {})
    configuration_protected_settings = optional(map(string), {})
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
      version   = optional(string)
    }))
  }))
  default = {}
}
