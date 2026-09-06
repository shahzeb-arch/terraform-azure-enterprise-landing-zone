module "this" {
  source = "../management-group-subs-association"

  management_group_id = var.management_group_id
  subscription_id     = var.subscription_id
}
