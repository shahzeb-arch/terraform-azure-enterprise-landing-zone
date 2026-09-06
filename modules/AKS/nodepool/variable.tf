variable "name" {
  type        = string
  description = "Name of the node pool (lowercase, max 12 chars)."
}

variable "kubernetes_cluster_id" {
  type        = string
  description = "Resource ID of the parent AKS cluster."
}

variable "vm_size" {
  type        = string
  description = "VM size for worker nodes."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where worker nodes will be placed."
}

variable "mode" {
  type        = string
  description = "Node pool mode: User for workloads, System for critical addons."
  default     = "User"

  validation {
    condition     = contains(["User", "System"], var.mode)
    error_message = "mode must be User or System."
  }
}

variable "os_type" {
  type        = string
  description = "Operating system type."
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "os_type must be Linux or Windows."
  }
}

variable "os_sku" {
  type        = string
  description = "OS SKU for nodes (AzureLinux, Ubuntu, Windows2019, Windows2022)."
  default     = "AzureLinux"
}

variable "priority" {
  type        = string
  description = "Priority: Regular or Spot."
  default     = "Regular"

  validation {
    condition     = contains(["Regular", "Spot"], var.priority)
    error_message = "priority must be Regular or Spot."
  }
}

variable "eviction_policy" {
  type        = string
  description = "Eviction policy for Spot nodes (Delete or Deallocate)."
  default     = null
}

variable "spot_max_price" {
  type        = number
  description = "Maximum price for Spot nodes (-1 for on-demand price cap)."
  default     = null
}

variable "node_count" {
  type        = number
  description = "Static node count when auto-scaling is disabled."
  default     = 3
}

variable "auto_scaling_enabled" {
  type        = bool
  description = "Enable cluster autoscaler for this node pool."
  default     = true
}

variable "min_count" {
  type        = number
  description = "Minimum nodes when auto-scaling is enabled."
  default     = 2
}

variable "max_count" {
  type        = number
  description = "Maximum nodes when auto-scaling is enabled."
  default     = 10
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB."
  default     = 128
}

variable "os_disk_type" {
  type        = string
  description = "OS disk type (Managed or Ephemeral)."
  default     = "Managed"
}

variable "zones" {
  type        = list(string)
  description = "Availability zones for the node pool."
  default     = ["1", "2", "3"]
}

variable "max_pods" {
  type        = number
  description = "Maximum pods per node."
  default     = 110
}

variable "node_labels" {
  type        = map(string)
  description = "Kubernetes labels applied to nodes."
  default     = {}
}

variable "node_taints" {
  type        = list(string)
  description = "Kubernetes taints applied to nodes."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Azure tags for the node pool."
  default     = {}
}

variable "upgrade_settings" {
  description = "Rolling upgrade settings for the node pool."
  type = object({
    max_surge                     = optional(string, "33%")
    drain_timeout_in_minutes      = optional(number, 0)
    node_soak_duration_in_minutes = optional(number, 0)
  })
  default = {
    max_surge = "33%"
  }
}
