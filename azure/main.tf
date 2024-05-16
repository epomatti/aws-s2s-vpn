terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.103.1"
    }
  }
}

locals {
  workload = "client"
  firewall = "pfsense"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

resource "azurerm_resource_group" "firewall" {
  name     = "rg-${local.workload}-${local.firewall}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "monitor" {
  source              = "./modules/monitor"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "vm_linux" {
  source              = "./modules/vm"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.compute_subnet_id
  size                = var.vm_linux_size
  image_sku           = var.vm_linux_image_sku
}

module "firewall" {
  count               = var.enable_firewall ? 1 : 0
  source              = "./modules/firewall"
  firewall_name       = "pfsense"
  resource_group_name = azurerm_resource_group.firewall.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.firewall_subnet_id
  size                = var.pfsense_vm_size
  image_publisher     = var.pfsense_publisher
  image_offer         = var.pfsense_offer
  image_sku           = var.pfsense_sku
  image_version       = var.pfsense_version
}
