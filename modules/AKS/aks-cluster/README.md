# AKS Private Cluster

## What it is
A private Azure Kubernetes Service (AKS) cluster. The **control plane (master)** is fully
managed by Azure — you do not create master VMs. This module creates the cluster with a
**system node pool** for critical addons (CoreDNS, metrics-server, etc.).

## When to use it (production)
- Private API server only (`private_cluster_enabled = true`)
- Azure AD RBAC + Workload Identity
- Azure Policy enabled
- Standard SKU for SLA
- Azure CNI overlay + UDR outbound (hub-spoke with firewall)

## Resources created
- `azurerm_kubernetes_cluster`

Worker/user workloads go in the separate `nodepool` module.

## Usage example
```hcl
module "aks_cluster" {
  source              = "../../modules/AKS/aks-cluster"
  cluster_name        = "aks-prod-app"
  location            = "East US"
  resource_group_name = "rg-prod-aks"
  dns_prefix          = "aksprodapp"

  system_node_pool = {
    vm_size   = "Standard_D4s_v5"
    subnet_id = module.subnet.id
  }

  network_profile = {
    service_cidr   = "10.240.0.0/16"
    dns_service_ip = "10.240.0.10"
    outbound_type  = "userDefinedRouting"
  }

  rbac = {
    admin_group_object_ids = [var.aks_admin_group_id]
  }
}
```

## Production defaults (built-in)
| Setting | Default |
|---|---|
| private_cluster_enabled | `true` |
| local_account_disabled | `true` |
| azure_policy_enabled | `true` |
| oidc_issuer_enabled | `true` |
| workload_identity_enabled | `true` |
| sku_tier | `Standard` |
| only_critical_addons_enabled (system pool) | `true` |

## Outputs
| Name | Description |
|---|---|
| id | Cluster resource ID |
| name | Cluster name |
| private_fqdn | Private API server FQDN |
| oidc_issuer_url | For workload identity |
| kube_config | Sensitive — bootstrap only |

## Production notes
- Master/control plane is **never** a separate Terraform resource in AKS.
- Pair with `nodepool` module for user/worker pools.
- Use `outbound_type = userDefinedRouting` when egress goes via Azure Firewall.
- Provide `private_dns_zone_id` or let Azure manage private DNS.
- Do not commit `kube_config` — use `az aks get-credentials` or pipeline SPN.
