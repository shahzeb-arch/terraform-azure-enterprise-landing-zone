# SQL Server

## What it is
Azure SQL logical server hosting one or more databases.

## Resources created
- azurerm_mssql_server

## Production notes
- Prefer Azure AD admin over SQL login in production.
- Disable public access; use private endpoint.
