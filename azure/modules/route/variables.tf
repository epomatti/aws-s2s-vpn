variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "aws_vpc_cidr" {
  type = string
}

variable "firewall_private_ip_address" {
  type = string
}

variable "compute_subnet_id" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}
