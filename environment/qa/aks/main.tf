module "resource_group" {
  for_each                = var.rgs
  source                  = "../../../modules/foundation/resourceGroup"
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = merge(var.common_tags, each.value.tags)
}

module "aks_cluster" {
  for_each = var.aks_clusters
  source   = "../../../modules/AKS/aks-cluster"

  cluster_name        = each.value.cluster_name
  location            = each.value.location
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version
  sku_tier            = each.value.sku_tier
  tags                = merge(var.common_tags, each.value.tags)

  private_cluster_enabled             = each.value.private_cluster_enabled
  private_dns_zone_id                 = each.value.private_dns_zone_id
  private_cluster_public_fqdn_enabled = each.value.private_cluster_public_fqdn_enabled

  local_account_disabled    = each.value.local_account_disabled
  azure_policy_enabled      = each.value.azure_policy_enabled
  oidc_issuer_enabled       = each.value.oidc_issuer_enabled
  workload_identity_enabled = each.value.workload_identity_enabled

  system_node_pool = merge(each.value.system_node_pool, {
    subnet_id = data.azurerm_subnet.this[each.value.subnet_lookup_key].id
  })

  network_profile = each.value.network_profile
  rbac            = each.value.rbac

  depends_on = [module.resource_group]
}

module "aks_nodepool" {
  for_each = var.aks_nodepools
  source   = "../../../modules/AKS/nodepool"

  name                  = each.value.name
  kubernetes_cluster_id = module.aks_cluster[each.value.cluster_key].id
  vm_size               = each.value.vm_size
  subnet_id             = data.azurerm_subnet.this[each.value.subnet_lookup_key].id
  mode                  = each.value.mode
  node_count            = each.value.node_count
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  os_disk_size_gb       = each.value.os_disk_size_gb
  zones                 = each.value.zones
  max_pods              = each.value.max_pods
  node_labels           = each.value.node_labels
  node_taints           = each.value.node_taints
  tags                  = merge(var.common_tags, each.value.tags)

  depends_on = [module.aks_cluster]
}
