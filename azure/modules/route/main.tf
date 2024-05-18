resource "azurerm_route_table" "aws" {
  name                          = "aws-route-table"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false
}

resource "azurerm_route" "aws" {
  name                   = "aws-route"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.aws.name
  address_prefix         = var.aws_route_cidr
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip_address
}

resource "azurerm_subnet_route_table_association" "compute" {
  subnet_id      = var.compute_subnet_id
  route_table_id = azurerm_route_table.aws.id
}
