data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = var.vpc_id
}

resource "aws_customer_gateway" "customer_gateway" {
  device_name     = "pfsense-azure"
  bgp_asn         = 65000
  ip_address      = var.customer_gateway_ip_address
  type            = "ipsec.1"
  certificate_arn = var.customer_gateway_certificate_arn

  tags = {
    Name = "pfsense-azure"
  }
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "ipsec.1"
  static_routes_only  = true

  # The IPv4 CIDR range on the customer gateway (on-premises) side that is allowed to communicate over the VPN tunnels.
  local_ipv4_network_cidr = var.customer_gateway_cidr

  # The IPv4 CIDR range on the AWS side that is allowed to communicate over the VPN tunnels.
  remote_ipv4_network_cidr = data.aws_vpc.selected.cidr_block
}

resource "aws_vpn_connection_route" "azure" {
  # This will be advertise to the VPC
  destination_cidr_block = var.customer_gateway_cidr
  vpn_connection_id      = aws_vpn_connection.main.id
}

# resource "aws_vpn_connection_route" "office" {
#   destination_cidr_block = "192.168.10.0/24"
#   vpn_connection_id      = aws_vpn_connection.main.id
# }

# resource "aws_vpn_gateway_route_propagation" "main" {
#   vpn_gateway_id = aws_vpn_gateway.example.id
#   route_table_id = aws_route_table.example.id
# }
