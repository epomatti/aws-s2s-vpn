### General ###
variable "location" {
  type = string
}

### VNET ###
variable "aws_vpc_cidr" {
  type = string
}

variable "aws_remote_gateway_ip_address_tunnel_1" {
  type = string
}

variable "aws_remote_gateway_ip_address_tunnel_2" {
  type = string
}

variable "local_administrator_ip_address" {
  type = string
}

### Virtual Machine ###
variable "enable_virtual_machine" {
  type = bool
}

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

variable "firewall_name" {
  type = string
}

variable "firewall_vm_size" {
  type = string
}

variable "firewall_image_publisher" {
  type = string
}

variable "firewall_image_offer" {
  type = string
}

variable "firewall_image_sku" {
  type = string
}

variable "firewall_image_version" {
  type = string
}

variable "firewall_plan_name" {
  type = string
}

variable "firewall_plan_publisher" {
  type = string
}

variable "firewall_plan_product" {
  type = string
}
