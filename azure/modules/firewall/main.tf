resource "azurerm_public_ip" "default" {
  name                = "pip-${var.firewall_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = "Regional"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "default" {
  name                = "nic-${var.firewall_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  # Based on the source ARM template
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  admin_username = "azureuser"
}

resource "azurerm_linux_virtual_machine" "default" {
  name                  = "vm-${var.firewall_name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = local.admin_username
  network_interface_ids = [azurerm_network_interface.default.id]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = local.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "osdisk-${var.firewall_name}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  plan {
    name      = var.plan_name
    publisher = var.plan_publisher
    product   = var.plan_product
  }
}
