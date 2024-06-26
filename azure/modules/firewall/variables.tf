variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type = string
}

### Image ###
variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "image_version" {
  type = string
}

variable "plan_name" {
  type = string
}

variable "plan_publisher" {
  type = string
}

variable "plan_product" {
  type = string
}

variable "public_key" {
  type = string
}
