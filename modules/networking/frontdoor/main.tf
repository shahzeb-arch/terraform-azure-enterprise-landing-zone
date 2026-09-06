resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tags                = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  for_each = var.endpoints

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  tags                     = merge(var.tags, each.value.tags)
}

resource "azurerm_cdn_frontdoor_firewall_policy" "this" {
  count = var.waf_policy != null ? 1 : 0

  name                              = var.waf_policy.name
  resource_group_name               = var.resource_group_name
  sku_name                          = var.waf_policy.sku_name
  enabled                           = var.waf_policy.enabled
  mode                              = var.waf_policy.mode
  redirect_url                      = var.waf_policy.redirect_url
  custom_block_response_status_code = var.waf_policy.custom_block_response_status_code
  custom_block_response_body        = var.waf_policy.custom_block_response_body
  tags                              = var.tags

  dynamic "managed_rule" {
    for_each = var.waf_policy.managed_rules
    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version
      action  = managed_rule.value.action
    }
  }
}
