# Key Vault Key

## What it is
Cryptographic key stored in Azure Key Vault with optional automatic rotation policy.

## Resources created
- azurerm_key_vault_key

## Usage example
```hcl
module "key_vault_key" {
  source       = "../../../modules/security/key-vault-key"
  name         = "cmk-platform"
  key_vault_id = module.key_vault.id
  rotation_policy = {
    expire_after         = "P90D"
    notify_before_expiry = "P29D"
    automatic = {
      time_before_expiry = "P30D"
    }
  }
}
```

## Production notes
- Use rotation_policy for CMK keys used by disk encryption sets and storage.
- Requires appropriate Key Vault permissions on the deploying identity.
