locals {
  cidr_prefix = "172.16"
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["${local.cidr_prefix}.0.0/16"]
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

### Network Security Group - Firewall###
resource "azurerm_network_security_group" "firewall" {
  name                = "nsg-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "firewall" {
  subnet_id                 = azurerm_subnet.firewall.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}

resource "azurerm_network_security_rule" "all_inbound" {
  name                        = "All"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.firewall.name
}

resource "azurerm_network_security_rule" "all_outbound" {
  name                        = "AllOutbound"
  priority                    = 1010
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.firewall.name
}

# resource "azurerm_network_security_rule" "ipsec" {
#   name                        = "IPSec"
#   priority                    = 2000
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "UDP"
#   source_port_range           = "*"
#   destination_port_range      = "500"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.firewall.name
# }

# resource "azurerm_network_security_rule" "natt" {
#   name                        = "NAT-T"
#   priority                    = 2010
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "UDP"
#   source_port_range           = "*"
#   destination_port_range      = "4500"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.firewall.name
# }

# resource "azurerm_network_security_rule" "openvpn" {
#   name                        = "OpenVPN"
#   priority                    = 2020
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "UDP"
#   source_port_range           = "*"
#   destination_port_range      = "1194"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.firewall.name
# }

# resource "azurerm_network_security_rule" "allow_inbound_ssh_firewall" {
#   name                        = "SSH"
#   priority                    = 1010
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "22"
#   source_address_prefix       = "*" # TODO: Close this down to a specific IP range
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.firewall.name
# }

# resource "azurerm_network_security_rule" "allow_inbound_ssh_https" {
#   name                        = "HTTPS"
#   priority                    = 1020
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "443" # 443
#   source_address_prefix       = "*" # TODO: Close this down to a specific IP range
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.firewall.name
# }

# resource "azurerm_network_security_rule" "allow_inbound_ssh_http" {
#   name                        = "HTTP"
#   priority                    = 1030
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   source_address_prefix       = "*" # TODO: Close this down to a specific IP range
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.firewall.name
# }

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

resource "azurerm_network_security_rule" "allow_inbound_ssh_application" {
  name                        = "SSH"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*" # TODO: Close this down to a specific IP range
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "icmp" {
  name                        = "ICMP"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*" # TODO: Close this down to a specific IP range
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}
