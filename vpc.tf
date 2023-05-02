module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  cidr                 = var.CIDR_BLOCK
  instance_tenancy     = var.INSTANCE_TENANCY
  enable_dns_hostnames = var.ENABLE_DNS_HOSTNAMES
  enable_dns_support   = var.ENABLE_DNS_SUPPORT
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets      = ["10.0.21.0/24", "10.0.22.0/24","10.0.23.0/24"]
  enable_nat_gateway   = true
  azs                  = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  vpc_tags = {
    Name = "${var.VPC_NAME}-${var.ENVIRONMENT}"
  }
  public_subnet_tags = {
    Name = "${var.PUBLIC_SUBNET_NAME}-${var.ENVIRONMENT}"
  }
  igw_tags = {
    Name = "${var.INTERNET_GATEWAY_NAME}-${var.ENVIRONMENT}"
  }
  public_route_table_tags = {
    Name = "${var.ROUTE_TABLE_NAME}-${var.ENVIRONMENT}"
  }
  private_subnet_tags = {
    Name = "${var.PRIVATE_SUBNET_NAME}-${var.ENVIRONMENT}"
  }
  nat_gateway_tags = {
    Name = "${var.NAT_GATEWAY_NAME}-${var.ENVIRONMENT}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  PRIMARY_AZ = element(data.aws_availability_zones.available.names, 0)
}

resource "aws_db_subnet_group" "private_sg" {
  name       = "main"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "demo-subnet-group"
  }
}