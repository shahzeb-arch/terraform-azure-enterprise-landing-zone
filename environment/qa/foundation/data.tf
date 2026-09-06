data "azurerm_billing_mca_account_scope" "this" {
  for_each = var.billing_scopes

  billing_account_name = each.value.billing_account_name
  billing_profile_name = each.value.billing_profile_name
  invoice_section_name = each.value.invoice_section_name
}
