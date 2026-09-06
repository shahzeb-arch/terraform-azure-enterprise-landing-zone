tenant_root_management_group_id = "/providers/Microsoft.Management/managementGroups/00000000-0000-0000-0000-000000000000"

management_groups = {
  "contoso" = {
    display_name = "Contoso Root"
  }
  "platform" = {
    display_name = "Platform"
  }
  "landing-zones" = {
    display_name = "Landing Zones"
  }
}

billing_scopes = {
  "primary_mca" = {
    billing_account_name = "0000000-0000-0000-0000-000000000000:00000000-0000-0000-0000-000000000000_2019-05-31"
    billing_profile_name = "AAAA-BBBB-CCCC-DDD"
    invoice_section_name = "EEEE-FFFF-GGG-HHH"
  }
}

subscriptions = {
  "corp-prod-sub" = {
    subscription_name           = "corp-prod-sub"
    alias                       = "corp-prod-sub"
    billing_scope_key           = "primary_mca"
    target_management_group_key = "landing-zones"
    tags = {
      Environment = "prod"
      Owner       = "platform-team"
    }
  }
}
