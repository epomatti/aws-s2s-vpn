### General ###
location = "eastus2"

### Virtual Machine ###
vm_linux_size      = "Standard_B2ps_v2"
vm_linux_image_sku = "22_04-lts-arm64"

### Firewall ###
enable_firewall   = true
pfsense_vm_size   = "Standard_B2as_v2"
pfsense_publisher = "netgate"
pfsense_offer     = "pfsense-plus-public-cloud-fw-vpn-router"
pfsense_sku       = "pfsense-plus-public-tac-lite"
pfsense_version   = "latest"
