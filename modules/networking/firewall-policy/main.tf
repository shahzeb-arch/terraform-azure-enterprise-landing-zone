resource "azurerm_firewall_policy" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  dns {
    proxy_enabled = var.dns_proxy_enabled
    servers       = var.dns_servers
  }
  threat_intelligence_mode = var.threat_intelligence_mode
  tags                     = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  count = var.rule_collection_group != null ? 1 : 0

  name               = var.rule_collection_group.name
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = var.rule_collection_group.priority

  dynamic "application_rule_collection" {
    for_each = var.rule_collection_group.application_rule_collections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name              = rule.value.name
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.destination_fqdns
          protocols {
            port = rule.value.protocol_port
            type = rule.value.protocol_type
          }
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = var.rule_collection_group.network_rule_collections
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = var.rule_collection_group.nat_rule_collections
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          destination_address = rule.value.destination_address
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
}
