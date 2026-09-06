resource "azurerm_api_management" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name
  zones               = var.zones
  tags                = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_configuration != null ? [var.virtual_network_configuration] : []
    content {
      subnet_id = virtual_network_configuration.value.subnet_id
    }
  }

  dynamic "protocols" {
    for_each = var.protocols != null ? [var.protocols] : []
    content {
      enable_http2 = protocols.value.enable_http2
    }
  }

  dynamic "security" {
    for_each = var.security != null ? [var.security] : []
    content {
      enable_backend_ssl30  = security.value.enable_backend_ssl30
      enable_backend_tls10  = security.value.enable_backend_tls10
      enable_backend_tls11  = security.value.enable_backend_tls11
      enable_frontend_ssl30 = security.value.enable_frontend_ssl30
      enable_frontend_tls10 = security.value.enable_frontend_tls10
      enable_frontend_tls11 = security.value.enable_frontend_tls11
    }
  }

  dynamic "sign_in" {
    for_each = var.sign_in != null ? [var.sign_in] : []
    content {
      enabled = sign_in.value.enabled
    }
  }

  dynamic "sign_up" {
    for_each = var.sign_up != null ? [var.sign_up] : []
    content {
      enabled = sign_up.value.enabled

      dynamic "terms_of_service" {
        for_each = sign_up.value.terms_of_service != null ? [sign_up.value.terms_of_service] : []
        content {
          enabled          = terms_of_service.value.enabled
          consent_required = terms_of_service.value.consent_required
          text             = terms_of_service.value.text
        }
      }
    }
  }
}
