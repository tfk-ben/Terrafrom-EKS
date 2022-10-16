provider "aws" {
    region = "eu-west-3"
}

#we need to create vpc with module 
#best practice create 1 public and 1 private subnet 
variable "vpc_cidr_block" {}
variable "private_subnets_cidr_block" {}
variable "public_subnets_cidr_block" {}

#to get all azs
data "aws_availability_zones" "available" {}


module "my-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.1"


  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets_cidr_block 
  public_subnets  = var.public_subnets_cidr_block 

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

  tags = {
        #like a lable 
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

    public_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        # elastic load balencer 
        "kubernetes.io/role/elb" = 1 
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/internal-elb" = 1 
    }

}