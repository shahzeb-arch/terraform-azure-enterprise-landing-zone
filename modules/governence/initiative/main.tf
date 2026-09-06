resource "azurerm_policy_set_definition" "this" {
  name                = var.name
  policy_type         = var.policy_type
  display_name        = var.display_name
  description         = var.description
  management_group_id = var.management_group_id

  dynamic "policy_definition_reference" {
    for_each = var.policy_definition_references
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      reference_id         = policy_definition_reference.value.reference_id
      parameter_values     = policy_definition_reference.value.parameter_values
      version              = policy_definition_reference.value.version
    }
  }

  dynamic "policy_definition_group" {
    for_each = var.policy_definition_groups
    content {
      name                            = policy_definition_group.value.name
      display_name                    = policy_definition_group.value.display_name
      description                     = policy_definition_group.value.description
      additional_metadata_resource_id = policy_definition_group.value.additional_metadata_resource_id
    }
  }

  parameters = var.parameters
  metadata   = var.metadata
}
