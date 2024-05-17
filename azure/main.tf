terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.103.1"
    }
  }
}

resource "random_string" "generated" {
  length  = 5
  special = false
  upper   = false
}

locals {
  affix    = random_string.generated.result
  workload = "enterprise"
  firewall = "pfsense-${local.affix}"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}-core-${local.affix}"
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
  count               = var.enable_virtual_machine ? 1 : 0
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
  firewall_name       = var.firewall_name
  resource_group_name = azurerm_resource_group.firewall.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.firewall_subnet_id
  size                = var.firewall_vm_size
  image_publisher     = var.firewall_image_publisher
  image_offer         = var.firewall_image_offer
  image_sku           = var.firewall_image_sku
  image_version       = var.firewall_image_version
  plan_name           = var.firewall_plan_name
  plan_publisher      = var.firewall_plan_publisher
  plan_product        = var.firewall_plan_product
}
