output "id" {
  description = "Policy assignment ID."
  value = (
    var.scope_type == "subscription" ? azurerm_subscription_policy_assignment.this[0].id :
    var.scope_type == "management_group" ? azurerm_management_group_policy_assignment.this[0].id :
    azurerm_resource_group_policy_assignment.this[0].id
  )
}

output "name" {
  description = "Policy assignment name."
  value = (
    var.scope_type == "subscription" ? azurerm_subscription_policy_assignment.this[0].name :
    var.scope_type == "management_group" ? azurerm_management_group_policy_assignment.this[0].name :
    azurerm_resource_group_policy_assignment.this[0].name
  )
}
