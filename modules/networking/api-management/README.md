# API Management

## What it is
Azure API Management gateway for publishing, securing, and monitoring APIs.

## Resources created
- azurerm_api_management

## Production notes
- Use Premium with VNet integration for production.
- Disable legacy TLS via `protocols` and `security` blocks.
