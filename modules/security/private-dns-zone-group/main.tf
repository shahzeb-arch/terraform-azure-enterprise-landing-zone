# Deprecated in azurerm 4.x — DNS zone groups are configured inline on the
# private-endpoint module via the `private_dns_zone_group` variable.
#
# Example (environment/dev/security/terraform.tfvars):
#
# private_endpoints = {
#   "pe_kv" = {
#     ...
#     private_dns_zone_group = {
#       name                 = "default"
#       private_dns_zone_ids = ["/subscriptions/.../privateDnsZones/privatelink.vaultcore.azure.net"]
#     }
#   }
# }
