# Azure CAF Enterprise Landing Zone

Production-grade Terraform implementation of the Microsoft Cloud Adoption Framework (CAF) Enterprise Landing Zone on Azure. Modular, layer-based state, and security-first defaults.

## Quick start

```powershell
# 1. Bootstrap remote state (one-time)
cd modules/foundation/state-backend
terraform init && terraform apply -var="location=East US" -var="storage_account_name=stterraformstate<unique>"

# 2. Deploy a layer (example: networking)
cd environment/dev/networking
terraform init -backend-config=../../../backend/dev.hcl -backend-config="key=dev/networking/terraform.tfstate"
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars

# 3. Validate all dev layers locally
./scripts/validate-all.ps1
```

See [docs/ELZ-DEPLOYMENT-GUIDE.md](docs/ELZ-DEPLOYMENT-GUIDE.md) for full apply order and [docs/ELZ-ARCHITECTURE.md](docs/ELZ-ARCHITECTURE.md) for hub-spoke design.

## Module coverage

| Category | Modules |
|----------|---------|
| **Foundation** | resourceGroup, management-group, subscription, management-group-subs-association, subscription-association, state-backend, management-lock, management-private-link |
| **Networking** | virtualNetwork, subnet, networkSecurityGroup, routeTable, nat_gateway, publicIP, private_DNS_vnet_link, virtual_network-peering, firewall, firewall-policy, bastion, load-balancer, vpn-gateway, expressroute-gateway, ddos-protection-plan, application-gateway, frontdoor |
| **Connectivity** | (environment layer wiring firewall, bastion, peering) |
| **Security** | key-vault, managed-identity, private-endpoint, private-dns-zone-group, defender, locks, disk-encryption-set |
| **Monitoring** | log-analytics, diagnostics-settings, action-group, alerts, sentinel, data-collection-rule |
| **Governance** | policy, initiative, policy-assignment, role-definition, role-assignment, budget |
| **Management** | automation-account |
| **Data** | storage-account |
| **Compute** | linux_virtualMachine, linux_vmss, windows-vmss, networkInterface, availability-set |
| **AKS** | aks-cluster, nodepool, extensions |
| **Shared** | naming |

## Environment layers

| Layer | Dev path | Purpose |
|-------|----------|---------|
| Foundation | `environment/dev/foundation` | Management groups, subscriptions |
| Networking | `environment/dev/networking` | Hub VNet, subnets, NSG, routes |
| Connectivity | `environment/dev/connectivity` | Firewall, bastion, peering |
| Security | `environment/dev/security` | Key Vault, identities, Defender |
| Monitoring | `environment/dev/monitoring` | Log Analytics, action groups |
| Sentinel | `environment/dev/sentinel` | Sentinel onboarding |
| Governance | `environment/dev/governance` | Policy, RBAC, budgets |
| Management | `environment/dev/management` | Automation accounts |
| Diagnostics | `environment/dev/diagnostics` | Cross-layer diagnostic settings |
| Compute | `environment/dev/compute` | VMs and VMSS |
| AKS | `environment/dev/aks` | Kubernetes platform |
| Landing zone | `environment/dev/landing-zone-corp` | Corp spoke VNet + hub peering |

QA (`10.1.0.0/16`, `rg-qa-*`) and Prod (`10.2.0.0/16`, `rg-prod-*`) mirror all dev layers under `environment/qa/*` and `environment/prod/*`.

## Backend configuration

| Environment | Config file | State key pattern |
|-------------|-------------|-------------------|
| Dev | `backend/dev.hcl` | `dev/<layer>/terraform.tfstate` |
| QA | `backend/qa.hcl` | `qa/<layer>/terraform.tfstate` |
| Prod | `backend/prod.hcl` | `prod/<layer>/terraform.tfstate` |

## CI/CD

GitHub Actions (`.github/workflows/terraform-ci.yml`):

- `terraform validate` matrix for all 12 dev layers
- Sample validate for qa/prod foundation
- **TFLint** on modules and environments
- **TFSec** security scanning
- **Checkov** policy scanning

## Policies

CAF initiative references and assignment guidance: [policies/caf/README.md](policies/caf/README.md)

## Design principles

Every module includes `main.tf`, `variable.tf`, `output.tf`, and `README.md` with:

- Primary resource label `this`
- Production-safe defaults (TLS 1.2, no public access, private endpoints)
- Dynamic blocks and `for_each` support at environment layers
- Diagnostic settings, RBAC, and private endpoint patterns where applicable
