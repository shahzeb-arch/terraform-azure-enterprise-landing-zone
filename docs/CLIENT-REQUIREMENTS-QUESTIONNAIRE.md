# Client ELZ Requirements Questionnaire

Use this checklist when scoping an Azure CAF Enterprise Landing Zone engagement. Map answers to `environment/<env>/*/terraform.tfvars`.

## 1. Organization & foundation

| Question | Layer | tfvars key |
|----------|-------|------------|
| Management group hierarchy names? | `foundation` | `management_groups` |
| How many subscriptions (platform, corp, online, etc.)? | `foundation` | `subscriptions` |
| Lock MG/subscription from deletion? | `foundation` | `management_locks` |

## 2. Networking

| Question | Layer | tfvars key |
|----------|-------|------------|
| Hub CIDR range? | `networking` | `virtual_networks` |
| Subnet layout (firewall, bastion, PE, AKS, gateway)? | `networking` | `subnets` |
| Outbound via NAT Gateway? | `networking` | `nat_gateway`, `nat_gateway_associations` |
| Private DNS zones for Private Link? | `networking` | `private_dns_zones`, `private_dns_vnet_links` |

## 3. Connectivity & hybrid

| Question | Layer | tfvars key |
|----------|-------|------------|
| Hub firewall required? | `connectivity` | `firewalls`, `firewall_policies` |
| Bastion for admin access? | `connectivity` | `bastion_hosts` |
| Site-to-site VPN or ExpressRoute? | `connectivity` | `vpn_gateways`, `expressroute_gateways` |
| DDoS Network Protection? | `connectivity` | `ddos_protection_plans` |
| WAF (App Gateway / Front Door)? | `connectivity` | `application_gateways`, `frontdoors` |
| Internal load balancers? | `connectivity` | `load_balancers` |
| Spoke peering? | `connectivity`, `landing-zone-corp` | `vnet_peerings` |

## 4. Security

| Question | Layer | tfvars key |
|----------|-------|------------|
| Platform Key Vault? | `security` | `key_vaults` |
| Private endpoints for PaaS? | `security` | `private_endpoints` |
| CMK / disk encryption sets? | `security` | `disk_encryption_sets` |
| Defender for Cloud plans? | `security` | `defender_plans` |
| Resource locks on critical RGs? | `security` | `locks` |

## 5. Monitoring & SIEM

| Question | Layer | tfvars key |
|----------|-------|------------|
| Central Log Analytics workspace? | `monitoring` | `log_analytics_workspaces` |
| Action groups / on-call emails? | `monitoring` | `action_groups` |
| AMA data collection rules? | `monitoring` | `data_collection_rules` |
| Metric alerts? | `monitoring` | `metric_alerts` |
| Microsoft Sentinel? | `sentinel` | `sentinel` config |
| Diagnostic settings to LAW? | `diagnostics` | `diagnostic_settings` |

## 6. Backup & DR

| Question | Layer | tfvars key |
|----------|-------|------------|
| Recovery Services Vault (GRS)? | `backup` | `recovery_services_vaults` |
| VM backup retention (daily/weekly/monthly)? | `backup` | `backup_policies_vm` |
| Which VMs to protect? | `backup` | `backup_protected_vms` |
| ASR replication policy (DR)? | `backup` | `site_recovery_replication_policies` |

## 7. Governance & cost

| Question | Layer | tfvars key |
|----------|-------|------------|
| CAF policy initiatives (ASB, CIS, ISO)? | `governance` | `policy_assignments` |
| Custom policies / initiatives? | `governance` | `policies`, `initiatives` |
| RBAC role assignments? | `governance` | `role_assignments` |
| Subscription budgets? | `governance` | `budgets` |

## 8. Compute & containers

| Question | Layer | tfvars key |
|----------|-------|------------|
| Platform VMs (Linux/Windows)? | `compute` | `linux_virtual_machines`, `windows_virtual_machines` |
| VMSS / availability sets? | `compute` | `linux_vmss`, `windows_vmss`, `availability_sets` |
| Private AKS cluster? | `aks` | `aks_clusters`, `aks_nodepools`, `aks_extensions` |

## 9. Data & automation

| Question | Layer | tfvars key |
|----------|-------|------------|
| Platform storage (diagnostics, logs)? | `data` | `storage_accounts` |
| Automation account / runbooks? | `management` | `automation_accounts` |

## 10. Environment matrix

| Environment | Hub CIDR | Backend key prefix |
|-------------|----------|-------------------|
| Dev | 10.0.0.0/16 | `dev/` |
| QA | 10.1.0.0/16 | `qa/` |
| Prod | 10.2.0.0/16 | `prod/` |

## Delivery workflow

1. Complete this questionnaire with the client.
2. Copy `environment/dev/*` → `environment/<client-env>/` or update existing env tfvars.
3. Replace placeholder IDs (subscription, tenant, principal, VM IDs).
4. Apply layers in order per `docs/ELZ-DEPLOYMENT-GUIDE.md`.
5. Run `./scripts/validate-all.ps1` before every apply.
