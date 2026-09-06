# Disk Encryption Set

## What it is
Customer-managed key (CMK) disk encryption set for VMs, VMSS, and AKS node disks.

## When to use it (production)
- Enforce CMK for regulated workloads.
- Grant DES identity unwrap/wrap permissions on Key Vault key.

## Resources created
- `azurerm_disk_encryption_set`

## Usage example
```hcl
module "des" {
  source              = "../../modules/security/disk-encryption-set"
  name                = "des-platform-prod"
  location            = "eastus"
  resource_group_name = "rg-prod-security"
  key_vault_key_id    = module.key_vault_key.id
}
```

## Production notes
- Enable auto key rotation when supported by Key Vault key policy.
- Use separate DES per environment or workload tier.
