### General ###
variable "location" {
  type = string
}

### Virtual Machine ###
variable "vm_linux_size" {
  type = string
}

variable "vm_linux_image_sku" {
  type = string
}

### Firewall ###
variable "enable_firewall" {
  type = bool
}

variable "pfsense_vm_size" {
  type = string
}

variable "pfsense_publisher" {
  type = string
}

variable "pfsense_offer" {
  type = string
}

variable "pfsense_sku" {
  type = string
}

variable "pfsense_version" {
  type = string
}
