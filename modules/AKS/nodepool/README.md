# AKS Node Pool (Worker)

## What it is
An additional AKS node pool for **worker nodes** that run your application workloads.
Separate from the system pool in `aks-cluster` (which runs critical cluster addons).

## When to use it (production)
- Separate pools per workload tier (app, gpu, spot, windows)
- Auto-scaling user pools (`mode = User`)
- Zone-redundant workers across 3 AZs
- Taints/labels for dedicated workloads

## Resources created
- `azurerm_kubernetes_cluster_node_pool`

## Usage example
```hcl
module "aks_nodepool_app" {
  source                = "../../modules/AKS/nodepool"
  name                  = "app"
  kubernetes_cluster_id = module.aks_cluster.id
  vm_size               = "Standard_D4s_v5"
  subnet_id             = module.subnet.id
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 10
  node_labels = {
    workload = "app"
  }
}
```

## Production notes
- Pool name max 12 chars, lowercase.
- Use `mode = User` for app workloads; system pool stays in cluster module.
- Spot pools: set `priority = Spot` + `eviction_policy = Delete`.
- Place workers in a dedicated AKS subnet with enough IP space.
