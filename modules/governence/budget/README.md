# Budget

## What it is
Subscription consumption budget with email alerts at configurable thresholds.

## When to use it (production)
- Set monthly budgets per subscription with 80% and 100% alerts.
- Filter by resource group for workload-specific cost control.

## Resources created
- `azurerm_consumption_budget_subscription`

## Usage example
```hcl
module "budget" {
  source          = "../../modules/governence/budget"
  name            = "budget-dev-sub"
  subscription_id = data.azurerm_subscription.current.id
  amount          = 5000
  time_period = {
    start_date = "2026-01-01"
    end_date   = "2026-12-31"
  }
  notifications = [{
    threshold      = 80
    operator       = "GreaterThan"
    contact_emails = ["finops@example.com"]
  }]
}
```

## Production notes
- Requires Cost Management Contributor on the subscription.
