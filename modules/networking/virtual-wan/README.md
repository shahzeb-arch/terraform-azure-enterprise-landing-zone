# Virtual WAN

## What it is
Azure Virtual WAN hub for large-scale branch-to-cloud and site-to-site connectivity.

## Resources created
- azurerm_virtual_wan

## Production notes
- Use Standard type for ExpressRoute, VPN, and Azure Firewall in vWAN hub.
- Add vWAN hub, connections, and routing in separate modules as needed.
