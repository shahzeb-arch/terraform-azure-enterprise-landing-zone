resource "azurerm_consumption_budget_subscription" "this" {
  name            = var.name
  subscription_id = var.subscription_id
  amount          = var.amount
  time_grain      = var.time_grain

  time_period {
    start_date = var.time_period.start_date
    end_date   = var.time_period.end_date
  }

  dynamic "notification" {
    for_each = var.notifications
    content {
      enabled        = notification.value.enabled
      threshold      = notification.value.threshold
      operator       = notification.value.operator
      contact_emails = notification.value.contact_emails
      threshold_type = notification.value.threshold_type
    }
  }

  dynamic "filter" {
    for_each = var.filter != null ? [var.filter] : []
    content {
      dynamic "dimension" {
        for_each = filter.value.dimensions
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }
}
