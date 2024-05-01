
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/my-cluster" = "shared"
  }

 public_subnet_tags = {
  "kubernetes.io/cluster/my-cluster" = "shared"
  "kubernetes.io/role/elb"           = "1"
  "subnet-type"                       = "public"
}

private_subnet_tags = {
  "kubernetes.io/cluster/my-cluster" = "shared"
  "kubernetes.io/role/internal-elb"  = "1"
  "subnet-type"                      = "private"
}

}

data "aws_availability_zones" "available" {}
