variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster."
}

variable "location" {
  type        = string
  description = "Azure region for the cluster."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the cluster will be created."
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the cluster API server."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version. Leave null to use latest supported by Azure."
  default     = null
}

variable "sku_tier" {
  type        = string
  description = "AKS SKU tier. Use Standard for production SLA."
  default     = "Standard"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be Free, Standard, or Premium."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the cluster."
  default     = {}
}

# --- Private cluster ---

variable "private_cluster_enabled" {
  type        = bool
  description = "Enable private API server endpoint (recommended for production)."
  default     = true
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS zone ID for the private API server FQDN. Null uses Azure-managed private DNS."
  default     = null
}

variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  description = "Enable public FQDN for private cluster (usually false in production)."
  default     = false
}

# --- Security / identity ---

variable "local_account_disabled" {
  type        = bool
  description = "Disable local Kubernetes accounts (use Azure AD RBAC only)."
  default     = true
}

variable "azure_policy_enabled" {
  type        = bool
  description = "Enable Azure Policy add-on for the cluster."
  default     = true
}

variable "oidc_issuer_enabled" {
  type        = bool
  description = "Enable OIDC issuer for workload identity."
  default     = true
}

variable "workload_identity_enabled" {
  type        = bool
  description = "Enable Azure Workload Identity."
  default     = true
}

variable "image_cleaner_enabled" {
  type        = bool
  description = "Enable image cleaner to prune unused images on nodes."
  default     = true
}

variable "http_application_routing_enabled" {
  type        = bool
  description = "Enable HTTP application routing (not recommended for production)."
  default     = false
}

variable "cost_analysis_enabled" {
  type        = bool
  description = "Enable cost analysis metrics for the cluster."
  default     = true
}

variable "identity" {
  description = "Managed identity for the cluster control plane."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = {
    type = "SystemAssigned"
  }

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned"], var.identity.type)
    error_message = "identity.type must be SystemAssigned or UserAssigned."
  }
}

variable "rbac" {
  description = "Azure AD RBAC configuration."
  type = object({
    azure_rbac_enabled     = optional(bool, true)
    admin_group_object_ids = optional(list(string), [])
    tenant_id              = optional(string)
  })
  default = {
    azure_rbac_enabled = true
  }
}

variable "key_vault_secrets_provider" {
  description = "Key Vault Secrets Provider (CSI driver) configuration."
  type = object({
    secret_rotation_enabled  = optional(bool, true)
    secret_rotation_interval = optional(string, "2m")
  })
  default = {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
}

# --- System node pool (required with cluster) ---

variable "system_node_pool" {
  description = "System node pool for critical cluster addons. Control plane is Azure-managed."
  type = object({
    name                = optional(string, "system")
    vm_size             = string
    subnet_id           = string
    node_count          = optional(number, 3)
    enable_auto_scaling = optional(bool, true)
    min_count           = optional(number, 2)
    max_count           = optional(number, 5)
    os_disk_size_gb     = optional(number, 128)
    os_disk_type        = optional(string, "Managed")
    os_sku              = optional(string, "AzureLinux")
    zones               = optional(list(string), ["1", "2", "3"])
    max_pods            = optional(number, 110)
    upgrade_settings = optional(object({
      max_surge                     = optional(string, "33%")
      drain_timeout_in_minutes      = optional(number, 0)
      node_soak_duration_in_minutes = optional(number, 0)
    }))
  })
}

# --- Networking ---

variable "network_profile" {
  description = "AKS network profile (Azure CNI recommended for production)."
  type = object({
    network_plugin      = optional(string, "azure")
    network_plugin_mode = optional(string, "overlay")
    network_policy      = optional(string, "cilium")
    outbound_type       = optional(string, "userDefinedRouting")
    load_balancer_sku   = optional(string, "standard")
    service_cidr        = string
    dns_service_ip      = string
    pod_cidr            = optional(string)
  })

  validation {
    condition     = contains(["azure", "kubenet", "none"], var.network_profile.network_plugin)
    error_message = "network_plugin must be azure, kubenet, or none."
  }

  validation {
    condition     = contains(["azure", "calico", "cilium"], var.network_profile.network_policy)
    error_message = "network_policy must be azure, calico, or cilium."
  }

  validation {
    condition     = contains(["loadBalancer", "userDefinedRouting", "managedNATGateway", "block"], var.network_profile.outbound_type)
    error_message = "outbound_type must be loadBalancer, userDefinedRouting, managedNATGateway, or block."
  }
}

# --- Optional maintenance / autoscaling ---

variable "maintenance_window" {
  description = "General maintenance window for the cluster."
  type = object({
    allowed = optional(list(object({
      day   = string
      hours = list(number)
    })), [])
    not_allowed = optional(list(object({
      end   = string
      start = string
    })), [])
  })
  default = null
}

variable "maintenance_window_auto_upgrade" {
  description = "Maintenance window for automatic control plane upgrades."
  type = object({
    frequency    = string
    interval     = number
    duration     = number
    day_of_week  = optional(string)
    day_of_month = optional(number)
    week_index   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    start_date   = optional(string)
    not_allowed = optional(object({
      end   = string
      start = string
    }))
  })
  default = null
}

variable "maintenance_window_node_os" {
  description = "Maintenance window for node OS upgrades."
  type = object({
    frequency    = string
    interval     = number
    duration     = number
    day_of_week  = optional(string)
    day_of_month = optional(number)
    week_index   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    start_date   = optional(string)
    not_allowed = optional(object({
      end   = string
      start = string
    }))
  })
  default = null
}

variable "auto_scaler_profile" {
  description = "Cluster autoscaler profile tuning."
  type = object({
    balance_similar_node_groups      = optional(bool)
    expander                         = optional(string)
    max_graceful_termination_sec     = optional(string)
    max_node_provisioning_time       = optional(string)
    max_unready_nodes                = optional(number)
    max_unready_percentage           = optional(number)
    new_pod_scale_up_delay           = optional(string)
    scale_down_delay_after_add       = optional(string)
    scale_down_delay_after_delete    = optional(string)
    scale_down_delay_after_failure   = optional(string)
    scale_down_unneeded              = optional(string)
    scale_down_unready               = optional(string)
    scale_down_utilization_threshold = optional(string)
    scan_interval                    = optional(string)
    skip_nodes_with_local_storage    = optional(bool)
    skip_nodes_with_system_pods      = optional(bool)
  })
  default = null
}
