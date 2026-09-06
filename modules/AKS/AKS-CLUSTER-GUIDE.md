# AKS Private Cluster — Quick Build Guide

Short reference: private cluster best practices, networking, auth, every block in our module,
and how to switch public ↔ private. Read this → build any cluster.

---

## 1. Private cluster — best practices (production)

1. **`private_cluster_enabled = true`** — API server sirf private endpoint pe (internet se direct access nahi).
2. **`local_account_disabled = true`** — local K8s admin accounts band; sirf Entra ID se login.
3. **`azure_rbac_enabled = true`** — Azure RBAC + Kubernetes RBAC integrate (Entra groups → K8s roles).
4. **`azure_policy_enabled = true`** — cluster pe policy guardrails (Pod Security, allowed images, etc.).
5. **`workload_identity_enabled + oidc_issuer_enabled = true`** — apps ko password-less Azure access (Key Vault, Storage).
6. **`sku_tier = Standard`** — production SLA (Free = no uptime SLA).
7. **Dedicated AKS subnet** — apne VNet me alag subnet; nodes yahi pe; subnet size plan karo (/24 minimum, scale ke hisab se bada).
8. **`outbound_type = userDefinedRouting`** — egress hub firewall / NAT se (ELZ hub-spoke pattern).
9. **System pool alag, worker pool alag** — system = `aks-cluster` module; app workloads = `nodepool` module.
10. **`kube_config` output commit mat karo** — access `az aks get-credentials` ya pipeline SPN se lo.

---

## 2. VNet / Subnet — kahan banta hai? Auto ya manual?

| Cheez | Kaun banata hai |
|---|---|
| **VNet** | **Tum** (`environment/dev/networking` → `virtualNetwork` module) |
| **AKS subnet** | **Tum** (same VNet me naya subnet, e.g. `snet-aks`, `/24` ya bada) |
| **Node VMs** | Azure AKS (subnet ID pass karte ho) |
| **Control plane (master)** | Azure fully managed — Terraform me resource nahi |
| **Node resource group `MC_*`** | Azure auto-banata hai (infra disks, LB, etc.) |

**Flow:**
```
networking layer  →  VNet + snet-aks banao
aks layer         →  subnet_id pass karo (system + worker dono me)
```

AKS **kabhi apna VNet auto-create nahi karta** (production me). Tumhara existing VNet (`vnet-1` in `rg-dev-network`) me **ek dedicated subnet** add karo → uska `id` module me do.

**Subnet delegation (optional):** AKS ke liye subnet delegation zaroori nahi; sirf enough IP space + NSG/UDR rules sahi hon.

---

## 3. Azure CNI Overlay + Cilium — IP kaun manage karta hai?

**Default module settings:**
```hcl
network_plugin      = "azure"
network_plugin_mode = "overlay"   # CNI overlay
network_policy      = "azure"     # ya "cilium" agar Cilium policy chahiye
```

| IP type | Kaun set karta hai | Overlap rule |
|---|---|---|
| **Node IP** | Tumhara **Azure subnet** (`subnet_id`) | VNet address space se |
| **Pod IP (overlay)** | Virtual — overlay network se | VNet se **overlap nahi** karta ✅ |
| **service_cidr** | **Tum define karte ho** (e.g. `10.240.0.0/16`) | VNet / peering / on-prem se **alag** hona chahiye |
| **dns_service_ip** | **Tum define karte ho** (e.g. `10.240.0.10`) | `service_cidr` ke andar hona chahiye |
| **pod_cidr (overlay)** | Overlay mode me usually **auto**; kubenet me manual | — |

**Samjho:** Apna VNet use karoge to **nodes** usi VNet ke subnet se IP lenge. **Pods** overlay pe virtual IP lenge — isliye har pod ke liye subnet me IP reserve nahi karna padta (classic Azure CNI ki tarah). **Services** ke liye `service_cidr` + `dns_service_ip` tumhe dena padta hai — ye Azure auto-pick nahi karta; non-overlapping choose karo.

**Cilium:** `network_policy = "cilium"` set karo agar Cilium network policy engine chahiye (advanced eBPF policies). Default `azure` bhi production-ready hai.

---

## 4. Authentication & Authorization (Microsoft Entra ID)

**Haan — ye option hai aur production me recommended:**

```hcl
rbac = {
  azure_rbac_enabled     = true
  admin_group_object_ids = ["<entra-group-object-id>"]  # cluster admin
  tenant_id              = "<optional-tenant-id>"
}
local_account_disabled = true
```

| Setting | Matlab |
|---|---|
| `azure_rbac_enabled = true` | Entra ID users/groups → Azure RBAC roles → K8s permissions |
| `admin_group_object_ids` | In groups ke members cluster admin ban jate hain |
| `local_account_disabled = true` | Static kubeconfig / local accounts band |

Login: `kubectl` + `kubelogin` (or Azure CLI) → Entra token se cluster access.

---

## 5. Public cluster banana ho to kya change karo?

| Setting | Private (default) | Public |
|---|---|---|
| `private_cluster_enabled` | `true` | **`false`** |
| `private_dns_zone_id` | optional / null | **null** (not needed) |
| `private_cluster_public_fqdn_enabled` | `false` | `false` |
| API access | VNet / VPN / ExpressRoute / Bastion jump | Internet se (restrict with authorized IP ranges if added) |

**File:** `modules/AKS/aks-cluster/variable.tf` defaults change karo **ya** env `terraform.tfvars` me override:
```hcl
private_cluster_enabled = false
```

Optional hardening (public pe): `api_server_access_profile` block add karo module me — `authorized_ip_ranges = ["<corp-ip>/32"]`.

---

## 6. Dynamic blocks — name, kaam, kya milega

### `aks-cluster` module (`main.tf`)

| Block / setting | Kis liye | Kya milega |
|---|---|---|
| **`default_node_pool`** (required) | System nodes — CoreDNS, metrics, etc. | Cluster chalne ke liye minimum pool; `only_critical_addons_enabled = true` |
| **`default_node_pool.upgrade_settings`** | System pool rolling upgrade | Zero/minimal downtime during node image upgrade; `max_surge = "33%"` |
| **`network_profile`** | CNI, outbound, service network | Pod/node networking + K8s Service IP range |
| **`identity`** | Cluster managed identity | Azure resources access (ACR, Key Vault, LB) bina secrets ke |
| **`azure_active_directory_role_based_access_control`** | Entra ID + Azure RBAC | SSO login, group-based admin/access |
| **`key_vault_secrets_provider`** | CSI driver for Key Vault secrets | Pods me secrets mount + auto rotation |
| **`maintenance_window`** | General maint. allowed/not_allowed times | Maintenance sirf approved windows me |
| **`maintenance_window_auto_upgrade`** | Control plane auto-upgrade schedule | `frequency`, `day_of_week`, `start_time`, `duration`, `interval` — K8s version upgrade kab ho |
| **`maintenance_window_node_os`** | Node OS patch schedule | Node image / OS update kab ho |
| **`auto_scaler_profile`** | Cluster Autoscaler tuning | Scale-up/down speed, thresholds — default se fine-tune |

### `nodepool` module (worker)

| Block / setting | Kis liye | Kya milega |
|---|---|---|
| **`upgrade_settings`** | Worker pool rolling upgrade | App pods drain + surge during upgrade |
| **`node_labels`** | K8s scheduler labels | `workload=app` → specific pool pe pod schedule |
| **`node_taints`** | Dedicated nodes | `gpu=true:NoSchedule` — sirf tolerated pods aayenge |
| **`auto_scaling_enabled` + min/max** | Per-pool autoscale | Load ke hisab se worker count |

**Labels & taints:** cluster module me nahi — **`nodepool` module** me (`node_labels`, `node_taints` variables).

---

## 7. Maintenance window — main fields (short)

**`maintenance_window_auto_upgrade` / `maintenance_window_node_os`:**

| Field | Matlab |
|---|---|
| `frequency` | `Daily`, `Weekly`, `AbsoluteMonthly`, `RelativeMonthly` |
| `interval` | Har kitne din/week/month |
| `duration` | Window kitni der (hours) |
| `day_of_week` | Weekly: `Monday`, `Sunday`, etc. |
| `day_of_month` | Monthly: 1–31 |
| `week_index` | `First`, `Second`, `Last` (relative monthly) |
| `start_time` | `"03:00"` (UTC ya utc_offset ke sath) |
| `utc_offset` | e.g. `+05:30` |
| `start_date` | Pehli window kab se |
| `not_allowed` | Blackout dates (start/end) — upgrade band |

**Example (Sunday 2 AM, 4 hours):**
```hcl
maintenance_window_node_os = {
  frequency   = "Weekly"
  interval    = 1
  duration    = 4
  day_of_week = "Sunday"
  start_time  = "02:00"
  utc_offset  = "+05:30"
}
```

---

## 8. Auto scaler profile — kab use karo?

Optional — default autoscaler kaafi cases me theek. Tune karo jab:
- scale-down bahut aggressive ho
- nodes jaldi scale-up na ho rahe hon

Key fields: `scale_down_unneeded`, `scale_down_utilization_threshold`, `scan_interval`, `skip_nodes_with_system_pods`.

---

## 9. Module call — minimal private cluster

```hcl
# Step 1: networking layer me pehle banao
# vnet-1 + subnet snet-aks (/24)

module "aks" {
  source              = "../../modules/AKS/aks-cluster"
  cluster_name        = "aks-prod"
  location            = "East US"
  resource_group_name = "rg-prod-aks"
  dns_prefix          = "aksprod"

  system_node_pool = {
    vm_size   = "Standard_D4s_v5"
    subnet_id = "<snet-aks-resource-id>"
  }

  network_profile = {
    service_cidr   = "10.240.0.0/16"
    dns_service_ip = "10.240.0.10"
    outbound_type  = "userDefinedRouting"
    network_policy = "cilium"   # optional
  }

  rbac = {
    admin_group_object_ids = ["<entra-admin-group-id>"]
  }
}

module "aks_workers" {
  source                = "../../modules/AKS/nodepool"
  name                  = "app"
  kubernetes_cluster_id = module.aks.id
  vm_size               = "Standard_D4s_v5"
  subnet_id             = "<snet-aks-resource-id>"
  node_labels           = { workload = "app" }
  node_taints           = []   # e.g. ["dedicated=app:NoSchedule"]
}
```

---

## 10. Cheat sheet — file map

| Change karna hai | File |
|---|---|
| Private ↔ Public | `variable.tf` → `private_cluster_enabled` |
| Subnet / node size | env tfvars → `system_node_pool`, `nodepool` module |
| Entra admin group | `rbac.admin_group_object_ids` |
| Service/Pod network | `network_profile.service_cidr`, `dns_service_ip` |
| Maintenance timing | `maintenance_window_*` variables |
| Worker labels/taints | `modules/AKS/nodepool` → `node_labels`, `node_taints` |
| Cilium policies | `network_profile.network_policy = "cilium"` |

---

**Related modules:** `modules/AKS/aks-cluster/README.md`, `modules/AKS/nodepool/README.md`
