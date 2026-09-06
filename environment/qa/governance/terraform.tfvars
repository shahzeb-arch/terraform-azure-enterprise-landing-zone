# Placeholder governance config — replace IDs and principal IDs before apply.
policy_assignments = {
  "assign_allowed_locations" = {
    name                 = "assign-allowed-locations-dev"
    display_name         = "Allowed locations (dev)"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-b6990fd9834e"
    scope_type           = "subscription"
    enforce              = false
  }
}

role_assignments = {
  "kv_secrets_user" = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-qa-security/providers/Microsoft.KeyVault/vaults/kv-qa-platform"
    principal_id         = "00000000-0000-0000-0000-000000000000"
    role_definition_name = "Key Vault Secrets User"
    principal_type       = "ServicePrincipal"
  }
}

budgets = {
  "budget_dev_sub" = {
    name   = "budget-qa-subscription"
    amount = 1000
    time_period = {
      start_date = "2026-01-01"
      end_date   = "2026-12-31"
    }
    notifications = [
      {
        threshold      = 80
        operator       = "GreaterThan"
        contact_emails = ["finops@example.com"]
      },
      {
        threshold      = 100
        operator       = "GreaterThan"
        contact_emails = ["finops@example.com"]
      }
    ]
  }
}
