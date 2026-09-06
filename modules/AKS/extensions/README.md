# AKS Cluster Extension

## What it is
Installs Azure Kubernetes Service cluster extensions (monitoring, policy, service mesh, etc.).

## When to use it (production)
- Deploy Azure Monitor container insights or policy extensions post-cluster creation.
- Pin release_train to stable in production.

## Resources created
- `azurerm_kubernetes_cluster_extension`

## Usage example
```hcl
module "aks_extension" {
  source         = "../../modules/AKS/extensions"
  name           = "azuremonitor"
  cluster_id     = module.aks_cluster.id
  extension_type = "microsoft.azuremonitor.containerservice"
}
```

## Production notes
- Validate extension compatibility with cluster Kubernetes version.
- Use protected settings for secrets.
