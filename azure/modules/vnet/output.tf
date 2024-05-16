output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "firewall_subnet_id" {
  value = azurerm_subnet.firewall.id
}

output "compute_subnet_id" {
  value = azurerm_subnet.compute.id
}
