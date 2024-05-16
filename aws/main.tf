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

### VPC ###
module "vpc" {
  source              = "./modules/vpc"
  region              = var.aws_region
  workload            = local.workload
  availability_zone_1 = local.availability_zone_1
  availability_zone_2 = local.availability_zone_2
}

module "private_instance" {
  count         = var.enable_private_instance ? 1 : 0
  source        = "./modules/instance"
  vpc_id        = module.vpc.vpc_id
  subnet        = module.vpc.private_subnet_id
  ami           = var.ami
  instance_type = var.instance_type
}
