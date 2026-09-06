# Subscription Association

## What it is
Alias wrapper around `management-group-subs-association` for CAF naming consistency.

## When to use it (production)
- Associate platform and landing zone subscriptions to the correct management group hierarchy.

## Resources created
- Delegates to `azurerm_management_group_subscription_association`

## Usage example
```hcl
module "sub_association" {
  source              = "../../modules/foundation/subscription-association"
  management_group_id = module.management_group.id
  subscription_id     = module.subscription.id
}
```

## Production notes
- Place subscriptions under landing zone MGs per CAF model.
- One association per subscription.
