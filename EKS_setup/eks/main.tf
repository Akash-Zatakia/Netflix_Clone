provider "aws" {
    region = "us-east-1"
    profile = "default"
    shared_credentials_files = "/Users/akash/.aws/credentials"
    access_key = ""
    secret_key = ""
}
variable "vpc_id" {}

data "aws_vpc" "netflix_clone" {
    tags = {
      Name = "netflix_clone"
    }
    cidr_block = "10.0.0.0/16"
    id = var.vpc_id
}

variable "subnet_id" {}

data "aws_subnet" "public_subnet" {
    tags = {
      Name = "public_subnet"
    }
    cidr_block = "10.0.1.0/24"
    id = var.subnet_id
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.24"

  cluster_endpoint_public_access = true

  vpc_id     = data.aws_vpc.netflix_clone.vpc_id
  subnet_ids = data.aws_subnet.public_subnet.subnet_id

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.large"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}