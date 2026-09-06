# Enterprise Landing Zone Deployment Guide

This guide describes the recommended apply order for deploying the Azure CAF Enterprise Landing Zone (ELZ) to a client tenant.

## Prerequisites

1. Azure subscription(s) and management group hierarchy access
2. Terraform >= 1.8.0 and Azure CLI authenticated
3. Bootstrap remote state (see step 1)
4. Update placeholder subscription/tenant IDs in `backend/*.hcl`

## Deployment order

Apply each layer independently with its own state file:

| Step | Layer | Path | Depends on |
|------|-------|------|------------|
| 1 | Bootstrap | `modules/foundation/state-backend` (one-time) | — |
| 2 | Governance | `environment/<env>/governance` | Bootstrap |
| 3 | Networking | `environment/<env>/networking` | Governance |
| 4 | Connectivity | `environment/<env>/connectivity` | Networking |
| 5 | Security | `environment/<env>/security` | Networking |
| 6 | Monitoring | `environment/<env>/monitoring` | Governance |
| 7 | Data | `environment/<env>/data` | Governance |
| 8 | Sentinel | `environment/<env>/sentinel` | Monitoring |
| 9 | Management | `environment/<env>/management` | Governance |
| 10 | Diagnostics | `environment/<env>/diagnostics` | Monitoring, Security, Networking, Data |
| 11 | Compute | `environment/<env>/compute` | Networking |
| 12 | Backup | `environment/<env>/backup` | Governance (protected VMs after Compute) |
| 13 | AKS | `environment/<env>/aks` | Networking, Security, Monitoring |
| 14 | Landing zones | `environment/<env>/landing-zone-corp` | Networking, Connectivity |

## Bootstrap remote state

```powershell
cd modules/foundation/state-backend
terraform init
terraform apply -var="location=East US" -var="storage_account_name=stterraformstate<unique>"
```

Create `backend/<env>.hcl` and initialize each layer:

```powershell
cd environment/dev/governance
terraform init -backend-config=../../../backend/dev.hcl -backend-config="key=dev/governance/terraform.tfstate"
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Repeat for each layer in the order above.

## Post-deployment

1. Assign CAF policy initiatives via `environment/<env>/governance` (see `policies/caf/README.md`)
2. Verify diagnostic settings in Log Analytics (`diagnostics` layer)
3. Onboard Sentinel data connectors as required
4. Configure spoke landing zones and peering (`landing-zone-corp`)

## Validation

Run all dev layer validations locally:

```powershell
./scripts/validate-all.ps1
```

## Environment promotion

- **QA**: `10.1.0.0/16` address space, `rg-qa-*` naming
- **Prod**: `10.2.0.0/16` address space, `rg-prod-*` naming

Copy tfvars patterns from `environment/dev/*` and update CIDRs, names, and backend keys.
