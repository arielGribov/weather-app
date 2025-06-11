module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  single_nat_gateway      = true

  vpc_tags = {
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
  tags = {
    Name = "Weathers_project"
  }
}


# Your subnet tagging is good, but map_public_ip_on_launch = true globally enables public IPs for all public subnet EC2s,
# which can lead to exposed workloads.
# lets do something like this - map_public_ip_on_launch = var.map_public_ip_on_launch
