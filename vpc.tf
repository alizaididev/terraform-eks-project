provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "azs" {}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = myapp-vpc
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true ## All private subnets will route their internet traffic through this single nat gateway.
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster/" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster/" = "shared" #>>> these tags are required as there will be no clue like which one subnet is for public and private 
    "kubernetes.io/role/elb" = 1
  }


  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster/" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}