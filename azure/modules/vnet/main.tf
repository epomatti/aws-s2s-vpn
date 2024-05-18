locals {
  cidr_prefix = "172.16"
  allowed_origins = [
    var.aws_remote_gateway_ip_address_tunnel_1,
    var.aws_remote_gateway_ip_address_tunnel_2,
    var.local_administrator_ip_address
  ]
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["${local.cidr_prefix}.0.0/16"] # TODO: Change to 12
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "firewall" {
  name                 = "firewall"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${local.cidr_prefix}.0.0/24"]
}

resource "azurerm_subnet" "compute" {
  name                 = "compute"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${local.cidr_prefix}.10.0/24"]
}

### Network Security Group - Firewall ###
resource "azurerm_network_security_group" "firewall" {
  name                = "nsg-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "firewall" {
  subnet_id                 = azurerm_subnet.firewall.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}

# Inbound rules
resource "azurerm_network_security_rule" "pfsense_web_admin" {
  name                        = "pfSenseWebAdmin"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [80, 443]
  source_address_prefix       = var.local_administrator_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.firewall.name
}

resource "azurerm_network_security_rule" "ipsec" {
  name                        = "IPSec"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "500"
  source_address_prefixes     = local.allowed_origins
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.firewall.name
}

resource "azurerm_network_security_rule" "natt" {
  name                        = "NAT-T"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "4500"
  source_address_prefixes     = local.allowed_origins
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.firewall.name
}

resource "azurerm_network_security_rule" "openvpn" {
  name                        = "OpenVPN"
  priority                    = 1030
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "1194"
  source_address_prefixes     = local.allowed_origins
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.firewall.name
}

# Outbound rules
resource "azurerm_network_security_rule" "outbound_from_aws_icmp" {
  name                         = "OutboundFromAWSICMP"
  priority                     = 1000
  direction                    = "Outbound"
  access                       = "Allow"
  protocol                     = "Icmp"
  source_port_range            = "*"
  destination_port_range       = "*"
  source_address_prefix        = "*"
  destination_address_prefixes = azurerm_subnet.compute.address_prefixes
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.firewall.name
}

resource "azurerm_network_security_rule" "outbound_from_aws" {
  name                         = "OutboundFromAWS"
  priority                     = 1010
  direction                    = "Outbound"
  access                       = "Allow"
  protocol                     = "*"
  source_port_range            = "*"
  destination_port_ranges      = [80, 443]
  source_address_prefix        = "*"
  destination_address_prefixes = azurerm_subnet.compute.address_prefixes
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.firewall.name
}

### Network Security Group - Application ###
resource "azurerm_network_security_group" "application" {
  name                = "nsg-application"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "application" {
  subnet_id                 = azurerm_subnet.compute.id
  network_security_group_id = azurerm_network_security_group.application.id
}

resource "azurerm_network_security_rule" "allow_admin_compute" {
  name                        = "SSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.local_administrator_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "HTTP"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [80, 443]
  source_address_prefixes     = [var.aws_vpc_cidr, var.local_administrator_ip_address]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "icmp" {
  name                        = "ICMP"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = [var.aws_vpc_cidr, var.local_administrator_ip_address]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "outbound_aws_http" {
  name                        = "OutboundToAWSHTTP"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [80, 443]
  source_address_prefix       = "*"
  destination_address_prefix  = var.aws_vpc_cidr
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "outbound_aws_icmp" {
  name                        = "OutboundToAWSICMP"
  priority                    = 1010
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = var.aws_vpc_cidr
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}
