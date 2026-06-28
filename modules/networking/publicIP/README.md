Arguments Reference
The following arguments are supported:

name - (Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created.

resource_group_name - (Required) The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created.

location - (Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created.

allocation_method - (Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic.

Note:
Dynamic Public IP Addresses aren't allocated until they're assigned to a resource (such as a Virtual Machine or a Load Balancer) by design within Azure. See ip_address argument.

Note:
Dynamic allocation is only available with Basic SKU public IP addresses. Since Basic SKU public IP addresses have been deprecated (see sku below), Dynamic allocation is no longer available for new public IP addresses.

zones - (Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created.
Note:
Availability Zones are only supported with a Standard SKU and in select regions at this time. Standard SKU Public IP Addresses that do not specify a zone are not zone-redundant by default.

ddos_protection_mode - (Optional) The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, and VirtualNetworkInherited. Defaults to VirtualNetworkInherited.

ddos_protection_plan_id - (Optional) The ID of DDoS protection plan associated with the public IP.

Note:
ddos_protection_plan_id can only be set when ddos_protection_mode is Enabled.

domain_name_label - (Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

domain_name_label_scope - (Optional) Scope for the domain name label. If a domain name label scope is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN. Possible values are NoReuse, ResourceGroupReuse, SubscriptionReuse and TenantReuse.

edge_zone - (Optional) Specifies the Edge Zone within the Azure Region where this Public IP should exist. Changing this forces a new Public IP to be created.

idle_timeout_in_minutes - (Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes.

ip_tags - (Optional) A mapping of IP tags to assign to the public IP. Changing this forces a new resource to be created.

Note:
IP Tag RoutingPreference requires multiple zones and Standard SKU to be set.

ip_version - (Optional) The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Defaults to IPv4.
Note:
Only Static IP address allocation is supported for IPv6.

public_ip_prefix_id - (Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created.

reverse_fqdn - (Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.

sku - (Optional) The SKU of the Public IP. Possible values are Basic, Standard, and StandardV2. Defaults to Standard. Changing this forces a new resource to be created.

Note:
Public IP Standard and StandardV2 SKUs require allocation_method to be set to Static.

Note:
sku can no longer be set to Basic as of 31 March 2025 for new resources. This also affects allocation_method set to Dynamic, as it is only available with the Basic SKU. Please see the Azure Update retirement notification for more information.

sku_tier - (Optional) The SKU Tier that should be used for the Public IP. Possible values are Regional and Global. Defaults to Regional. Changing this forces a new resource to be created.
Note:
When sku_tier is set to Global, sku must be set to Standard.

tags - (Optional) A mapping of tags to assign to the resource.