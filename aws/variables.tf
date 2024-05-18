variable "aws_region" {
  type = string
}

variable "enable_private_instance" {
  type = bool
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "customer_gateway_ip_address" {
  type = string
}

variable "customer_gateway_cidr" {
  type = string
}

variable "enable_vpn" {
  type = bool
}

variable "enable_acmpca" {
  type = bool
}

variable "acmpca_common_name" {
  type = string
}
