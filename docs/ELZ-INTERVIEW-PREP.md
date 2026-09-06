# Azure Enterprise Landing Zone — Interview Prep Guide

> **Target level:** 5+ years Azure / Cloud / Platform Engineering  
> **Scope:** Microsoft CAF, Azure Landing Zone (ALZ), Hub-Spoke, Terraform IaC, Security, Identity, Operations  
> **How to use:** Read each question, answer aloud in 2–3 minutes, then compare with the model answer. Scenario sections are designed for system design / architect rounds.

---

## Table of Contents

1. [Answer Framework (Senior Engineer Style)](#answer-framework-senior-engineer-style)
2. [Governance & Management Groups](#1-governance--management-groups)
3. [Subscriptions & Landing Zone Model](#2-subscriptions--landing-zone-model)
4. [Networking — Hub-Spoke & vWAN](#3-networking--hub-spoke--vwan)
5. [Application Gateway vs Front Door vs Load Balancer](#4-application-gateway-vs-front-door-vs-load-balancer)
6. [Private Link, DNS & PaaS Access](#5-private-link-dns--paas-access)
7. [VM / App → SQL & Data Tier](#6-vm--app--sql--data-tier)
8. [Identity, RBAC & Key Vault](#7-identity-rbac--key-vault)
9. [AKS in Enterprise Landing Zone](#8-aks-in-enterprise-landing-zone)
10. [Monitoring, Sentinel & Operations](#9-monitoring-sentinel--operations)
11. [Policy, Compliance & FinOps](#10-policy-compliance--finops)
12. [Terraform & IaC at Scale](#11-terraform--iac-at-scale)
13. [Scenario-Based Design Questions](#12-scenario-based-design-questions)
14. [Rapid-Fire Tough Questions](#13-rapid-fire-tough-questions)
15. [Cheat Sheet (Last-Day Revision)](#14-cheat-sheet-last-day-revision)

---

## Answer Framework (Senior Engineer Style)

Interviewers at senior level don't want definitions — they want **decisions, trade-offs, and production experience**.

Use this structure for every answer:

```
1. CONTEXT     — "In an enterprise ELZ with hub-spoke and platform subscriptions..."
2. DECISION    — "We chose X because..."
3. TRADE-OFF   — "Alternative was Y, but we rejected it because..."
4. OPERATIONS  — "Day-2 we handle it via monitoring, policy, runbooks..."
5. SECURITY    — "From a security standpoint, we enforce..."
```

**Phrases that signal 5-year experience:**

- "We inherited policy at the management group level so child subscriptions don't drift."
- "We separated platform subscriptions from landing zone subscriptions for blast radius and billing."
- "Public network access is disabled by default; Private Endpoint is the standard pattern."
- "Terraform state is per layer, not one monolithic state file."
- "We validate in CI with `terraform validate`, TFLint, and Checkov before any apply."

---

## 1. Governance & Management Groups

### Q1. What is the purpose of Management Groups in an Enterprise Landing Zone?

**Model answer:**

Management Groups are the **policy and RBAC inheritance hierarchy** at tenant scope. They are not where resources live — subscriptions sit under them.

In a typical ALZ design we create:

- **Platform** → Connectivity, Management, Identity, Security
- **Landing Zones** → Corp, Online
- **Sandbox** → experimentation
- **Decommissioned** → retiring subscriptions with deny policies

We assign Azure Policy, initiatives (e.g. Azure Security Benchmark), and RBAC at the MG level so every child subscription inherits baseline controls. This gives us **one place to enforce** allowed regions, tagging, encryption, and diagnostic settings — without configuring each subscription individually.

**Trade-off:** Deep MG trees increase policy troubleshooting complexity. We keep the hierarchy shallow (2–3 levels) and document inheritance explicitly.

---

### Q2. Management Group vs Subscription vs Resource Group — explain with an example.

**Model answer:**

| Layer | Purpose | Example |
|-------|---------|---------|
| **Management Group** | Policy/RBAC inheritance | `Platform > Connectivity` |
| **Subscription** | Billing + admin boundary | `sub-connectivity-prod` |
| **Resource Group** | Lifecycle grouping | `rg-prod-hub-network` |
| **Resource** | Actual service | `vnet-hub-eastus` |

Example: The Connectivity subscription sits under the Connectivity MG. It inherits ASB policies from Platform. Inside the sub we have `rg-hub-network` containing hub VNet, Firewall, Bastion. Application teams never deploy into this subscription — it's platform-owned.

---

### Q3. What policies do you assign at Platform MG vs Landing Zone MG?

**Model answer:**

**Platform MG (strict):**

- Azure Security Benchmark initiative
- Require diagnostic settings to Log Analytics
- Deny public IP on NICs (where applicable)
- Enforce tagging (Environment, CostCenter, Owner)
- Allowed locations / restricted SKUs for platform resources

**Landing Zones MG:**

- Allowed locations for app teams
- Require Private Link for PaaS (custom policy)
- Enforce backup on VMs
- Deny resource types in Corp that shouldn't exist (e.g. sandbox SKUs in prod)

**Sandbox MG:**

- Lighter enforcement — allow cheaper SKUs, shorter retention
- Budget alerts mandatory

**Decommissioned MG:**

- Deny all resource creation — only drain and delete

---

### Q4. Tough: A new team wants their own subscription under Corp. Walk me through provisioning.

**Model answer:**

1. **Request intake** — app name, environment, cost center, network CIDR requirement, compliance tier
2. **Governance** — create or assign subscription, place under `Landing Zones > Corp` MG via `subscription_placements`
3. **Network** — allocate spoke CIDR from IPAM, create spoke VNet, peer to hub
4. **Policy** — inherits Corp + Landing Zone policies automatically
5. **RBAC** — grant team Contributor on their RG(s), not on subscription; platform team keeps Network Contributor on networking RGs
6. **Monitoring** — diagnostic settings policy ensures logs flow to central Log Analytics
7. **Terraform** — new landing zone layer or tfvars entry; separate state file (`prod/landing-zone-finance/terraform.tfstate`)
8. **Handoff** — runbook for PE requests, KV access, AKS onboarding if applicable

This is **subscription vending** — automated in mature orgs via Azure Portal vending or Terraform + pipeline.

---

## 2. Subscriptions & Landing Zone Model

### Q5. Platform subscription vs Landing Zone subscription — what's the difference?

**Model answer:**

**Platform subscriptions** host **shared services** for the entire estate:

| Subscription | Hosts |
|--------------|-------|
| Connectivity | Hub VNet, Firewall, VPN/ER, Bastion, Private DNS |
| Management | Log Analytics, Automation, Monitor, Backup vault (sometimes) |
| Identity | AD DS / identity tooling (optional, often merged) |
| Security | Sentinel, security tooling, central Key Vault (optional) |

**Landing Zone subscriptions** host **application workloads**:

- Corp LZ — internal apps, backend, on-prem connected
- Online LZ — internet-facing apps

**Why separate:** Blast radius, billing chargeback, different policy sets, different ops teams. A compromised app subscription shouldn't give access to hub firewall config.

---

### Q6. What is the Decommissioned management group for?

**Model answer:**

It's a **quarantine zone** for subscriptions being retired — not a design area for new workloads.

Process:

1. Migrate or delete all resources
2. Move subscription to Decommissioned MG
3. Apply **Deny** policies — no new resources
4. Revoke RBAC except break-glass admin
5. Cancel subscription after validation

Interview tip: Never say "we deploy test resources in Decommissioned." That shows misunderstanding.

---

### Q7. How many subscriptions should a mid-size enterprise start with?

**Model answer:**

**Minimum viable ELZ (5–6 subs):**

1. Connectivity
2. Management
3. Security (or merge with Management)
4. Corp Landing Zone (pilot)
5. Sandbox
6. (Identity — optional at start)

Scale to **10–20+** as app teams get dedicated landing zone subscriptions. Don't create 14 subscriptions on day one with full network stacks in each — that's over-engineering.

---

## 3. Networking — Hub-Spoke & vWAN

### Q8. Explain hub-spoke topology in an Enterprise Landing Zone.

**Model answer:**

```
                    On-Prem
                       |
              VPN / ExpressRoute
                       |
              ┌─── Hub VNet ───┐
              │   Firewall    │
              │   Bastion     │
              │   VPN GW      │
              │   Private DNS │
              └───┬───────┬───┘
                  |       |
            Peering   Peering
                  |       |
            Spoke A     Spoke B
            (Corp LZ)   (Corp LZ)
            App VMs     AKS
```

- **Hub** — shared connectivity, security inspection, hybrid connectivity
- **Spoke** — application landing zones, isolated by VNet
- **Peering** — spoke-to-hub; typically hub gateway transit enabled
- **UDR** — default route `0.0.0.0/0` → Azure Firewall private IP for forced egress inspection

**Key subnets in hub:** AzureFirewallSubnet (`/26`), GatewaySubnet, AzureBastionSubnet, optional AzureFirewallManagementSubnet.

---

### Q9. Hub-Spoke vs Virtual WAN — when do you choose each?

**Model answer:**

| Factor | Hub-Spoke | Virtual WAN |
|--------|-----------|-------------|
| Scale | Small–medium enterprise | Large, multi-region, many branches |
| Complexity | You manage peering, UDR, NVAs | Microsoft manages hub scale-out |
| Branch connectivity | VPN/ER to hub VNet | VPN/ER/site-to-site into vWAN hub |
| Firewall | Azure Firewall in hub VNet | Azure Firewall in vWAN hub (secured virtual hub) |
| Terraform/IaC | Mature patterns, full control | More abstraction, faster global rollout |
| Cost | Predictable per region | Can be higher at scale but ops cost lower |

**My rule:** Start hub-spoke for first region. Move to vWAN when you have **3+ regions**, **50+ sites**, or **managed global transit** requirements.

---

### Q10. What is forced tunneling and why is it used in ELZ?

**Model answer:**

Forced tunneling sends **all internet-bound traffic** from spokes through the hub firewall (or on-prem) instead of direct outbound via NAT Gateway.

Implementation:

- UDR on spoke subnets: `0.0.0.0/0` → next hop Virtual Appliance (Firewall private IP)
- Disable direct internet on spoke VMs (no public IP)
- NAT Gateway on spoke only if policy allows split egress (less common in strict ELZ)

**Why:** Centralized inspection, consistent egress IP allowlisting, DLP, threat detection via Firewall + Sentinel.

**Trade-off:** Hairpin latency, firewall becomes critical path — design HA firewall (zones), monitor throughput.

---

### Q11. Scenario: Spoke app needs to reach on-prem SQL. Design the path.

**Model answer:**

```
Spoke VM (10.1.64.4)
  → UDR to Firewall (10.0.1.4)
    → Hub Firewall policy: allow 10.1.64.0/18 → on-prem 192.168.10.0/24:1433
      → VPN/ExpressRoute gateway in hub
        → On-prem SQL
```

Checklist I'd mention:

- DNS resolution for on-prem (custom DNS forwarder or Azure DNS Private Resolver)
- NSG on VM subnet — outbound 1433 to hub/firewall only
- Firewall application rule + network rule
- No public endpoint on anything
- Log Analytics + Sentinel alert on denied flows

---

## 4. Application Gateway vs Front Door vs Load Balancer

### Q12. Compare Application Gateway, Front Door, and Azure Load Balancer.

**Model answer:**

| | **Load Balancer** | **Application Gateway** | **Front Door** |
|--|-------------------|-------------------------|----------------|
| **OSI Layer** | L4 (TCP/UDP) | L7 (HTTP/S) | L7 (HTTP/S) |
| **Scope** | Regional | Regional | **Global** |
| **SSL termination** | ❌ | ✅ | ✅ |
| **WAF** | ❌ | ✅ (WAF v2) | ✅ (edge WAF) |
| **URL routing** | ❌ | ✅ | ✅ |
| **CDN** | ❌ | ❌ | ✅ |
| **Use case** | Internal TCP load balance | Regional web app + WAF | Global entry, CDN, multi-region |

---

### Q13. Can you use Application Gateway and Front Door together?

**Model answer:**

Yes — common enterprise pattern:

```
Global users → Front Door (edge WAF, CDN, geo-routing, DDoS)
                 → App Gateway per region (regional WAF, VNet integration)
                    → VMSS / App Service / AKS ingress
                       → SQL via Private Endpoint
```

- **Front Door** — global traffic management, cache static assets, failover between regions
- **App Gateway** — regional fine-grained routing, private backend pools inside VNet

**When NOT to use both:** Single region, internal-only app → Internal App Gateway alone is enough.

---

### Q14. Internal vs External Application Gateway?

**Model answer:**

- **External (public frontend IP)** — internet-facing apps in Online landing zone
- **Internal (private frontend IP only)** — Corp apps accessed via private network, VPN, or Private Link

Internal AppGW sits in a dedicated subnet; backends can be VMSS with no public IP. Combine with Private DNS for internal FQDN.

---

## 5. Private Link, DNS & PaaS Access

### Q15. Private Endpoint vs Service Endpoint — which do you use in ELZ and why?

**Model answer:**

**Private Endpoint (standard in ELZ):**

- PaaS gets a **private IP** in your VNet
- Traffic stays on Microsoft backbone, **no public internet**
- Works with `public_network_access_enabled = false`
- Unified model for SQL, Storage, KV, ACR, etc.
- Requires **Private DNS Zone** (`privatelink.database.windows.net`, etc.)

**Service Endpoint (legacy):**

- Routes traffic to PaaS via service tag on subnet
- PaaS public endpoint often still enabled
- Simpler but less isolation

**Senior answer:** "We standardized on Private Endpoint across all PaaS in production. Service Endpoints only if legacy constraint."

---

### Q16. Explain Private DNS Zone setup for Private Link.

**Model answer:**

When SQL has a Private Endpoint:

1. Create PE in `snet-private-endpoints` subnet
2. Create Private DNS Zone `privatelink.database.windows.net`
3. Create A record: `myserver` → PE private IP
4. Link DNS zone to **every VNet** that needs resolution (hub + spokes)
5. Enable `private_dns_zone_group` on the PE resource

Result: App uses `myserver.database.windows.net` — resolves to private IP automatically. No code change when moving from public to private.

---

## 6. VM / App → SQL & Data Tier

### Q17. How does a VM in a spoke access Azure SQL securely?

**Model answer:**

**Network:**

1. Azure SQL — `public_network_access_enabled = false`
2. Private Endpoint in hub or spoke PE subnet
3. Private DNS zone linked to spoke VNet
4. NSG — VM outbound to PE subnet on 1433

**Authentication:**

- **Managed Identity** (preferred) — no password in connection string
- Azure AD admin configured on SQL server
- SQL user: `CREATE USER [vm-name] FROM EXTERNAL PROVIDER`

**Connection string example:**

```
Server=tcp:myserver.database.windows.net,1433;
Database=mydb;
Authentication=Active Directory Managed Identity;
Encrypt=True;
```

**What NOT to say:** "We allow the VM's public IP on SQL firewall" in production.

---

### Q18. VM and SQL in different subscriptions — does it work?

**Model answer:**

Yes — same Azure AD tenant. Requirements:

- VNet peering between spoke (VM) and VNet containing PE (or PE in same spoke)
- Private DNS zone linked to **both** VNets (or hub DNS forwarding via Azure DNS Private Resolver)
- RBAC: VM's Managed Identity needs SQL DB role (not subscription Contributor)

Cross-subscription is **standard** in ELZ — platform sub may host shared DNS; app sub hosts VM + SQL.

---

### Q19. Scenario: App Service needs SQL access. Difference from VM?

**Model answer:**

| | VM | App Service |
|--|-----|-------------|
| Identity | System/User Assigned MI | Built-in MI (enable in app) |
| Network | VNet integration + PE | VNet integration + PE, `vnet_route_all_enabled = true` |
| SQL auth | AAD MI | Same — AAD MI |
| Egress | UDR via firewall | Route all via VNet integration |

App Service without VNet integration accessing private SQL **won't work** if public SQL is disabled.

---

## 7. Identity, RBAC & Key Vault

### Q20. How do you design RBAC in an Enterprise Landing Zone?

**Model answer:**

**Principles:**

- **Least privilege** — app teams get Contributor on their RGs only
- **Separation of duties** — network team owns hub RGs, security owns KV policies
- **PIM** — privileged roles (Owner, UAA) are eligible, not permanent
- **Service principals / MI** for automation — not user accounts in pipelines

**Typical roles:**

| Team | Scope | Role |
|------|-------|------|
| Platform | Platform subs | Custom role or Contributor on platform RGs |
| App team | Their LZ RG | Contributor |
| Security | MG / KV | Key Vault Administrator (PIM) |
| Read-only ops | MG | Reader + Monitoring Reader |

**Policy vs RBAC:** Policy **denies** non-compliant creates; RBAC controls **who can act**.

---

### Q21. Key Vault design in ELZ — public or private?

**Model answer:**

Production standard:

- `public_network_access_enabled = false`
- Private Endpoint + Private DNS (`privatelink.vaultcore.azure.net`)
- `rbac_authorization_enabled = true` (not access policies)
- Purge protection + soft delete enabled
- CMK keys with **rotation policy** (auto-rotate before expiry)
- Disk Encryption Set references versionless key URI

Apps access via Managed Identity — `Key Vault Secrets User` role.

---

## 8. AKS in Enterprise Landing Zone

### Q22. How do you deploy AKS in a hub-spoke Enterprise Landing Zone?

**Model answer:**

**Placement:** AKS in **landing zone spoke**, not connectivity sub.

**Network:**

- Dedicated subnets: `snet-aks-nodes`, `snet-aks-pods` (Azure CNI overlay or Cilium)
- UDR: pod egress → Azure Firewall
- API server: private cluster (recommended) or authorized IP ranges
- Ingress: Internal AppGW or AGIC; public via Front Door → AppGW

**Identity:**

- Kubelet / cluster MI for ACR pull, KV, Disk CSI
- Azure AD integration for RBAC (AAD groups → K8s roles)

**Security:**

- Defender for Containers
- Azure Policy for AKS (allowed registries, no privileged containers)
- Workload identity for app → SQL/KV

**Monitoring:** Container Insights → Log Analytics; diagnostic settings on API server audit logs.

---

### Q23. AKS egress — NAT Gateway vs Azure Firewall?

**Model answer:**

| | NAT Gateway | Azure Firewall |
|--|-------------|----------------|
| Inspection | ❌ No L7 inspect | ✅ Full inspect + threat intel |
| Static egress IP | ✅ Simple | ✅ Via SNAT |
| ELZ standard | Dev/test only | **Production default** |
| Latency | Lower | Slightly higher |

In ELZ: **Firewall for production egress**; NAT GW only if policy exception for non-sensitive outbound.

---

## 9. Monitoring, Sentinel & Operations

### Q24. Central logging architecture in ELZ?

**Model answer:**

```
All platform + landing zone resources
  → Diagnostic Settings (policy-enforced)
    → Log Analytics Workspace (Management sub)
      → Azure Monitor Alerts → Action Groups
      → Microsoft Sentinel (Security sub / same workspace)
      → Workbooks + Grafana (optional)
```

**Key tables:** `AzureDiagnostics`, `SecurityEvent`, `ContainerLog`, `AppServiceHTTPLogs`, Firewall logs.

**AMA (Azure Monitor Agent)** + DCR replaces legacy Log Analytics agent.

**Retention:** 90–365 days hot in LA; archive to Storage Account for compliance.

---

### Q25. How do you operationalize Azure Firewall in ELZ?

**Model answer:**

- **Firewall Policy** (central) — rule collection groups by priority: base → app → dev
- **DNS Proxy** enabled → forward to Azure DNS Private Resolver
- **Threat intelligence** — Alert mode first, then Deny
- **Diagnostics** — application and network rules logged to LA
- **Sentinel analytics** — detect denied outbound to malicious IPs
- **Change control** — Terraform for rules; no portal edits in prod
- **DR** — firewall in paired region or vWAN secured hub

---

## 10. Policy, Compliance & FinOps

### Q26. How do you roll out Azure Policy without breaking existing workloads?

**Model answer:**

1. **Audit mode first** — `enforce = false`, review compliance for 2–4 weeks
2. **Remediate** — deploy remediation tasks for deploy-if-not-exists policies (diagnostics, tags)
3. **Deny gradually** — start with Sandbox, then Corp, then Platform
4. **Exemptions** — time-bound exemptions with ticket reference; never permanent
5. **CI validation** — Terraform plan checked against policy before apply

**Interview line:** "I've never enabled Deny on day one for ASB across the tenant — we always audit first."

---

### Q27. FinOps in Landing Zone design?

**Model answer:**

- **Budgets** at subscription level (connectivity, each LZ) with 80/90/100% alerts
- **Mandatory tags** — CostCenter, Environment, Owner (policy enforced)
- **Subscription vending** — chargeback per app team subscription
- **Sandbox auto-shutdown** — Automation runbooks
- **Reserved Instances / Savings Plans** for stable platform workloads (Firewall, LA)
- **Policy** — deny expensive SKUs in non-prod

---

## 11. Terraform & IaC at Scale

### Q28. How do you structure Terraform for Enterprise Landing Zone?

**Model answer (aligned with this repo):**

```
modules/           → reusable leaf modules (1 resource type each)
environment/
  dev/
    governance/    → MG, subs, policy, RBAC
    networking/    → vnet, subnet, nsg
    connectivity/  → firewall, bastion, peering
    security/      → kv, mi, defender
    monitoring/    → log analytics, alerts
    ...
```

**State strategy:** One state file **per layer per environment**:

```
dev/governance/terraform.tfstate
dev/networking/terraform.tfstate
dev/connectivity/terraform.tfstate
```

**Why not one state:** Blast radius, parallel applies, team ownership, smaller plan files.

**Apply order:** Bootstrap → Governance → Networking → Connectivity → Security → Monitoring → Workloads

---

### Q29. How do you handle cross-layer dependencies in Terraform?

**Model answer:**

- **Data sources** — downstream layer reads existing resources by name/RG (e.g. connectivity reads hub VNet from networking)
- **Remote state** (optional) — `terraform_remote_state` for outputs like VNet ID, LA workspace ID
- **Never** one giant module for everything
- **Contract:** upstream layer exports IDs/names; downstream consumes via data.tf

Example: AKS layer uses `data.azurerm_subnet` for node subnet created in networking layer.

---

### Q30. Terraform CI/CD best practices for ELZ?

**Model answer:**

- PR → `terraform fmt`, `validate`, TFLint, Checkov/TFSec
- Plan on PR comment (OIDC to Azure, no stored SP secret)
- Apply on merge to main with approval gate
- Separate pipeline per layer or matrix strategy
- Drift detection weekly
- State locking via Azure Storage backend
- No manual portal changes in prod (policy deny helps)

---

## 12. Scenario-Based Design Questions

### Scenario 1: Greenfield Enterprise Landing Zone — 5000 users, 3 apps, hybrid with on-prem

**Ask:** Design the full landing zone.

**Model answer outline:**

1. **Governance:** MG hierarchy, 6 subscriptions (Connectivity, Management, Security, 2× Corp LZ, Sandbox)
2. **Identity:** Azure AD, PIM, break-glass accounts documented
3. **Network:** Single region hub `/16`, 2 spokes `/18` each, ER primary + VPN backup
4. **Security:** Firewall in hub, Private DNS, KV with PE, Defender + Sentinel
5. **Apps:** Each app in own Corp LZ sub, AKS or App Service, SQL with PE + MI auth
6. **Ops:** Central LA, diagnostics policy, backup policy, Automation for patching
7. **IaC:** Terraform per layer, GitHub Actions CI, state in Management sub storage
8. **Phase 2:** Second region, Front Door for online app, ASR for DR

---

### Scenario 2: App team says "we need public SQL for faster development"

**Model answer:**

"I'd push back in prod. For **dev Sandbox** we can allow public with IP-restricted firewall as a **time-bound exception** with audit. For **Corp/Prod**, standard is Private Endpoint only — public disabled, MI auth, SQL firewall not used for access control. If they're blocked, I'd check: VNet integration configured? Private DNS linked? MI has SQL user created? Usually it's a networking gap, not a need for public SQL."

---

### Scenario 3: Hub firewall went down — what's the impact and mitigation?

**Model answer:**

**Impact:** All forced-tunneled spoke egress fails; hybrid traffic may fail; apps can't reach internet or on-prem via hub.

**Mitigation:**

- Azure Firewall in **availability zones** (99.95% SLA)
- Firewall Policy separate from resource — quick redeploy
- **Break-glass UDR** runbook — temporary route to NAT Gateway (documented, requires approval)
- Monitor firewall health metrics + Sentinel alert
- **DR region** with pre-peered standby hub (active/passive or active/active for critical)

---

### Scenario 4: Multi-region active-active for a global web app

**Model answer:**

```
Users → Front Door (Premium, WAF, geo-routing)
          → Region A: AppGW → AKS
          → Region B: AppGW → AKS
Both regions → Cosmos DB / SQL geo-replica (read/write strategy per app)
Central LA → Sentinel
DNS → Front Door handles global DNS
```

Platform: **two connectivity subs** or one sub with hub per region; vWAN if scale warrants.

---

### Scenario 5: Compliance requires all data encrypted with customer-managed keys

**Model answer:**

- Key Vault in Security sub with HSM keys (Premium SKU)
- **Key rotation policy** on CMK keys
- Disk Encryption Sets for VMs
- Storage CMK via MI
- SQL TDE with CMK
- Policy: deny resources without CMK in prod MG
- Terraform modules: `key-vault-key`, `disk-encryption-set`

---

### Scenario 6: 10 application teams want isolated environments — how do you scale?

**Model answer:**

- **Subscription vending** — template pipeline creates new Corp LZ sub from golden Terraform module
- **IPAM** — automated CIDR allocation from central registry
- **Peering** — hub peering automated per spoke
- **Policy inheritance** — no custom policy per team at start
- **Self-service** — portal or ServiceNow → pipeline → new `landing-zone-{team}` layer
- **Guardrails** — allowed SKUs, mandatory tags, PE required, no public IPs

Platform team maintains **golden hub**; app teams can't modify hub resources.

---

### Scenario 7: Terraform state file corrupted in production — what do you do?

**Model answer:**

1. **Stop all applies** immediately
2. Restore state from **blob versioning** on storage account (state backend in Management sub)
3. Run `terraform refresh` to reconcile
4. If resource drift — import missing resources or remove stale state entries
5. Root cause — concurrent apply without lock, manual portal delete
6. Prevent — state locking, no manual changes, branch protection, drift detection

---

## 13. Rapid-Fire Tough Questions

| # | Question | One-line senior answer |
|---|----------|------------------------|
| 1 | MG vs Subscription? | MG = policy tree; Subscription = billing/admin boundary |
| 2 | Platform vs Landing Zone? | Platform = shared infra subs; LZ = app workload subs |
| 3 | Corp vs Online? | Corp = internal/private; Online = internet-facing |
| 4 | Sandbox purpose? | Short-lived POC; relaxed policy; budget alerts |
| 5 | Decommissioned purpose? | Retiring subs; deny all new resources |
| 6 | Hub-spoke vs vWAN? | Hub-spoke for most; vWAN for global scale |
| 7 | L4 vs L7 load balance? | LB = TCP/UDP; AppGW/AFD = HTTP/S |
| 8 | AppGW vs Front Door? | AppGW = regional; AFD = global edge + CDN |
| 9 | PE vs Service Endpoint? | PE = private IP, no public; standard for ELZ |
| 10 | VM to SQL auth? | Managed Identity + Azure AD; no SQL password |
| 11 | Why disable SQL public? | Force all traffic via Private Link |
| 12 | Azure Firewall subnet size? | `/26` minimum for AzureFirewallSubnet |
| 13 | Bastion vs Jump box VM? | Bastion = PaaS, no public IP on VMs, audit logs |
| 14 | Sentinel vs Defender? | Defender = CSPM/CWPP; Sentinel = SIEM on LA |
| 15 | Policy Audit vs Deny? | Audit first in rollout; Deny in prod after remediate |
| 16 | One Terraform state? | No — per layer per env for blast radius |
| 17 | CMK vs PMK? | CMK for compliance control; PMK default Azure-managed |
| 18 | AKS private cluster? | API server no public endpoint; prod standard |
| 19 | Forced tunneling? | All egress via firewall for inspection |
| 20 | Tagging strategy? | Environment, Owner, CostCenter — policy enforced |

---

## 14. Cheat Sheet (Last-Day Revision)

### Must-draw diagrams (practice on whiteboard)

1. MG hierarchy tree with Platform + Landing Zones + Sandbox + Decommissioned
2. Hub-spoke with Firewall, peering, UDR to firewall
3. Private Endpoint + Private DNS flow for SQL
4. Front Door → AppGW → App → SQL (global app)
5. Terraform layer apply order + state file split

### Must-say security defaults

- Public network access **off** on PaaS
- Private Endpoint **on**
- Managed Identity **over** secrets
- Azure AD auth **over** SQL auth
- Diagnostics to Log Analytics **mandatory**
- No permanent Owner — **PIM eligible**

### Red flags — never say in interview

- "We put everything in one subscription for simplicity"
- "SQL public endpoint is fine with a strong password"
- "We manage firewall rules manually in the portal in prod"
- "One Terraform state file for the whole landing zone"
- "Decommissioned MG is where we deploy dev test VMs"
- "Service Principal with Contributor on root MG for CI/CD"

### Green flags — say these

- "Policy inheritance at MG level with audit-before-deny rollout"
- "Separate platform and landing zone subscriptions"
- "Private Link as standard; DNS zones linked to all required VNets"
- "Terraform state per layer; data sources for cross-layer refs"
- "Central Log Analytics with Sentinel for correlation"
- "Subscription vending for app team onboarding"

---

## Mock Interview — Self Test (30 min)

Answer these without looking:

1. Design hub-spoke for hybrid org with 2 app teams (whiteboard)
2. VM in spoke → Azure SQL — network + auth + DNS
3. AppGW vs Front Door vs LB — when each?
4. Platform subscription mein kya hota hai vs Corp landing zone?
5. Policy rollout strategy for existing estate
6. AKS egress through firewall — how?
7. Decommissioned MG workflow
8. Terraform state strategy — why not monolith?
9. Multi-region DR with Front Door — sketch
10. Key Vault CMK rotation — how and why?

---

*Document version: 1.0 — aligned with Microsoft CAF / ALZ and this repository's layer model (`environment/dev/*`, `modules/*`).*
