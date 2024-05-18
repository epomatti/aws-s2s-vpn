terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  workload = "startup"

  availability_zone_1 = "${var.aws_region}a"
  availability_zone_2 = "${var.aws_region}b"
}

module "vpc" {
  source              = "./modules/vpc"
  region              = var.aws_region
  workload            = local.workload
  availability_zone_1 = local.availability_zone_1
  availability_zone_2 = local.availability_zone_2
}

module "private_instance" {
  count                 = var.enable_private_instance ? 1 : 0
  source                = "./modules/instance"
  vpc_id                = module.vpc.vpc_id
  subnet                = module.vpc.private_subnet_id
  ami                   = var.ami
  instance_type         = var.instance_type
  customer_gateway_cidr = var.customer_gateway_cidr
}

module "acm" {
  count             = var.enable_acmpca ? 1 : 0
  source            = "./modules/acm"
  acmca_common_name = var.acmpca_common_name
}

module "vpn" {
  count                            = var.enable_vpn ? 1 : 0
  source                           = "./modules/vpn"
  vpc_id                           = module.vpc.vpc_id
  customer_gateway_ip_address      = var.customer_gateway_ip_address
  customer_gateway_cidr            = var.customer_gateway_cidr
  customer_gateway_certificate_arn = var.enable_acmpca ? module.acm[0].customer_gateway_certificate_arn : null
  route_tables_ids                 = module.vpc.route_tables_ids
}
