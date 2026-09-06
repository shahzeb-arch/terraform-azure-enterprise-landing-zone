output "id" {
  description = "SQL server ID."
  value       = azurerm_mssql_server.this.id
}

output "name" {
  description = "SQL server name."
  value       = azurerm_mssql_server.this.name
}

output "fully_qualified_domain_name" {
  description = "SQL server FQDN."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}
