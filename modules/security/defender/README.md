# Defender

## What it is
Microsoft Defender for Cloud subscription pricing plans per resource type.

## When to use it (production)
- Enable Standard tier for VMs, Storage, SQL, Containers, and Key Vaults.
- Apply consistently at subscription scope via the security layer.

## Resources created
- `azurerm_security_center_subscription_pricing` (one per resource type)

## Usage example
```hcl
module "defender" {
  source = "../../modules/security/defender"
  resource_types = ["VirtualMachines", "StorageAccounts", "SqlServers"]
}
```

## Production notes
- Requires Security Admin permissions on the subscription.
