# Microsoft ALZ-aligned governance layer (Foundation + Governance merged).
# Replace placeholder subscription IDs before apply.

tenant_root_management_group_id = "/providers/Microsoft.Management/managementGroups/00000000-0000-0000-0000-000000000000"

# Standard ALZ management group hierarchy
management_groups = {
  "platform" = {
    display_name = "Platform"
  }
  "connectivity" = {
    display_name              = "Connectivity"
    parent_management_group_key = "platform"
  }
  "management" = {
    display_name              = "Management"
    parent_management_group_key = "platform"
  }
  "identity" = {
    display_name              = "Identity"
    parent_management_group_key = "platform"
  }
  "security" = {
    display_name              = "Security"
    parent_management_group_key = "platform"
  }
  "landingzones" = {
    display_name = "Landing Zones"
  }
  "corp" = {
    display_name              = "Corp"
    parent_management_group_key = "landingzones"
  }
  "online" = {
    display_name              = "Online"
    parent_management_group_key = "landingzones"
  }
  "sandbox" = {
    display_name = "Sandbox"
  }
  "decommissioned" = {
    display_name = "Decommissioned"
  }
}

# Microsoft ALZ: one subscription per platform MG (use existing subs)
subscription_placements = {
  "sub_connectivity" = {
    subscription_id             = "00000000-0000-0000-0000-000000000001"
    target_management_group_key = "connectivity"
  }
  "sub_management" = {
    subscription_id             = "00000000-0000-0000-0000-000000000002"
    target_management_group_key = "management"
  }
  "sub_identity" = {
    subscription_id             = "00000000-0000-0000-0000-000000000003"
    target_management_group_key = "identity"
  }
  "sub_security" = {
    subscription_id             = "00000000-0000-0000-0000-000000000004"
    target_management_group_key = "security"
  }
  "sub_corp" = {
    subscription_id             = "00000000-0000-0000-0000-000000000005"
    target_management_group_key = "corp"
  }
}

# Optional: create NEW subscriptions via MCA billing (comment out if using placements only)
# billing_scopes = { ... }
# subscriptions = { ... }

policy_assignments = {
  "asb_platform" = {
    name                 = "caf-azure-security-benchmark"
    display_name         = "CAF - Azure Security Benchmark"
    policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-8471-7860b76b1a7e"
    scope_type           = "management_group"
    management_group_key = "platform"
    enforce              = false
  }
  "allowed_locations" = {
    name                 = "assign-allowed-locations"
    display_name         = "Allowed locations"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-b6990fd9834e"
    scope_type           = "management_group"
    management_group_key = "landingzones"
    enforce              = false
  }
}

role_assignments = {
  "kv_secrets_user" = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000004/resourceGroups/rg-dev-security/providers/Microsoft.KeyVault/vaults/kv-dev-platform"
    principal_id         = "00000000-0000-0000-0000-000000000000"
    role_definition_name = "Key Vault Secrets User"
    principal_type       = "ServicePrincipal"
  }
}

budgets = {
  "budget_connectivity" = {
    name             = "budget-connectivity-sub"
    subscription_key = "sub_connectivity"
    amount           = 5000
    time_period = {
      start_date = "2026-01-01"
      end_date   = "2026-12-31"
    }
    notifications = [
      {
        threshold      = 80
        operator       = "GreaterThan"
        contact_emails = ["finops@example.com"]
      }
    ]
  }
}
