resource "azurerm_security_center_subscription_pricing" "this" {
  for_each      = toset(var.resource_types)
  tier          = var.tier
  resource_type = each.value
  subplan       = lookup(var.subplans, each.value, null)
}
