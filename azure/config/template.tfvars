### General ###
location = "eastus2"

### Virtual Machine ###
enable_virtual_machine = false
vm_linux_size          = "Standard_B2pts_v2"
vm_linux_image_sku     = "22_04-lts-arm64"

### Firewall ###
enable_firewall  = true
firewall_name    = "pfsense"
firewall_vm_size = "Standard_B2als_v2"

firewall_image_publisher = "netgate"
firewall_image_offer     = "pfsense-plus-public-cloud-fw-vpn-router"
firewall_image_sku       = "pfsense-plus-public-tac-lite"
firewall_image_version   = "latest"

firewall_plan_name      = "pfsense-plus-public-tac-lite"
firewall_plan_publisher = "netgate"
firewall_plan_product   = "pfsense-plus-public-cloud-fw-vpn-router"
