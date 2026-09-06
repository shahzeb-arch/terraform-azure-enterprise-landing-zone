resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id      = var.subnet_id
  nat_gateway_id = var.nat_gateway_id
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  for_each = toset(var.public_ip_address_ids)

  nat_gateway_id       = var.nat_gateway_id
  public_ip_address_id = each.value
}
