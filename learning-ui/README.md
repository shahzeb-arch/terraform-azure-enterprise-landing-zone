# K8s Architect Playbook

**Foundation → Deep → Architect** — production me Kubernetes kaise socha jata hai.

## Open

```powershell
cd learning-ui
start index.html
```

Refresh: `Ctrl+F5`

## Learning Path (Home page)

1. **Learning Path** — how to use
2. **01 Foundation** — all basics (2 slides each)
3. **02–08 Deep** — production depth per section
4. **12 Troubleshooting** — 24 prod scenarios
5. **13 Labs** — 3-tier hands-on

## Sections (50+ topics)

| # | Section |
|---|---------|
| 00 | Start Here |
| 01 | Foundation (Pod, Deploy, Svc, NS, RBAC...) |
| 02 | Workloads Deep (every Deployment field, STS, DS, Job, HPA, VPA) |
| 03 | Namespace Deep (Quota, Entra ID RBAC) |
| 04 | Storage Deep (Azure Disk, Files, CSI+MI) |
| 05 | Networking Deep (Service, Ingress, NetPol rules, CNI, E2E) |
| 06 | Cluster Design (VNet/CIDR, Public vs Private, Multi-AZ) |
| 07 | Security Deep (RBAC, WI, Key Vault CSI, PSS/OPA) |
| 08 | Platform Internals (etcd, worker node, node upgrade) |
| 09 | Observability |
| 10 | Delivery (CI/CD, WIF, OWASP, ArgoCD, Helm) |
| 11 | Architect (mindset, DR, cost) |
| 12 | Troubleshooting (24 scenarios) |
| 13 | Labs |

## Gold Standard Topic

**02 Workloads Deep → Deployment (8-Section)** — template for all topics.

## AI Assistant

```powershell
cd learning-ui\chat-api
.\run.ps1
```

## Files

```
topics-slides-foundation.js    ← 01 Foundation
topics-slides-workloads-deep.js ← 02 Workloads
topics-slides-deep-extras.js   ← 03-12 Deep + 24 troubleshooting
topics-slides-v2-architect.js  ← 8-section templates
k8s/examples/deployment-production.yaml ← commented YAML
k8s/examples/service-production.yaml
k8s/examples/ingress-production.yaml
k8s/examples/networkpolicy-production.yaml
k8s/examples/secretproviderclass-example.yaml
```
