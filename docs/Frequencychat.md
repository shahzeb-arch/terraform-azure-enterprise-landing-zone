Tier 1 — Har ELZ mein (must-have)
├── Management Groups + Subscriptions
├── Resource Groups
├── Policy + RBAC
├── Hub VNet + Subnets + NSG + Routes
├── Azure Firewall (or NVA)
├── Log Analytics + Diagnostics
├── Key Vault + Managed Identity
└── Private DNS (Private Link ke saath)

Tier 2 — 80% enterprise clients
├── Bastion
├── VNet Peering (hub-spoke)
├── Private Endpoints
├── Defender for Cloud
├── Backup (RSV)
├── Sentinel (security team ho to)
└── Budgets / Cost management

Tier 3 — Client-specific
├── VPN / ExpressRoute / vWAN
├── APIM, App Gateway, Front Door
├── AKS + ACR
├── SQL, Postgres, Redis, Cosmos, ADF, Databricks
├── App Service / Function App
└── Multi-region hub


Governance     → MG, Subs, Policy, RBAC, Budget     [GRIP]
Networking     → VNet, Subnet, NSG, NAT, DNS          [Foundation]
Connectivity   → Firewall, Bastion, VPN, APIM, vWAN   [Network edge]
Security       → KV, MI, PE, Defender, CMK keys        [Trust]
Monitoring     → LA, Alerts, DCR, Sentinel             [Observe]
Management     → Automation Account                   [Ops]
Data           → Storage, SQL, Redis, Mongo, etc.       [When needed]
Compute/AKS    → VMs, App Service, AKS                 [Workloads]
Backup         → RSV, policies                         [Resilience]