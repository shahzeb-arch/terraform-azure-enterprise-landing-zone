resource "azurerm_data_factory" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  public_network_enabled = var.public_network_enabled
  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  tags                = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "github_configuration" {
    for_each = var.github_configuration != null ? [var.github_configuration] : []
    content {
      account_name    = github_configuration.value.account_name
      branch_name     = github_configuration.value.branch_name
      repository_name = github_configuration.value.repository_name
      root_folder     = github_configuration.value.root_folder
      git_url         = github_configuration.value.git_url
    }
  }

  dynamic "global_parameter" {
    for_each = var.global_parameters
    content {
      name  = global_parameter.value.name
      type  = global_parameter.value.type
      value = global_parameter.value.value
    }
  }
}
