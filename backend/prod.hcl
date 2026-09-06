resource_group_name  = "rg-terraform-state"
storage_account_name = "stterraformstate"
container_name       = "tfstate"
key                  = "prod/<layer>/terraform.tfstate"
use_azuread_auth     = true
subscription_id      = "00000000-0000-0000-0000-000000000000"
tenant_id            = "00000000-0000-0000-0000-000000000000"
