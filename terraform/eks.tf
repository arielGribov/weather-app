module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    = var.eks_name
  cluster_version = var.eks_version

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  cluster_addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = local.public_and_private_subnets_ids

  eks_managed_node_groups = {
    weather = {
      min_size                     = 2
      max_size                     = 4
      desired_size                 = 2
      instance_types               = ["t3.medium", "m5.large"]
      iam_role_additional_policies = { SSM = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" }
    }
  }
  cluster_security_group_additional_rules = {
    allow_networking_from_nodes = {
      name                       = "sg1"
      type                       = "ingress"
      from_port                  = 0
      to_port                    = 0
      protocol                   = "-1"
      source_node_security_group = true
      description                = "allow inbound networking from nodes"
    }
  }

  node_security_group_additional_rules = {
    allow_inbound_networking_from_cluster = {
      name                          = "sg2"
      type                          = "ingress"
      from_port                     = 0
      to_port                       = 0
      protocol                      = "-1"
      source_cluster_security_group = true
      description                   = "allow inbound networking from api_cluster"
    }
    allow_inbound_networking_from_node = {
      name                     = "sg3"
      type                     = "ingress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      source_security_group_id = module.eks.node_security_group_id
      description              = "allow traffic from node to node"
    }
    allow_inbound_networking_from_alb = {
      name                     = "sg4"
      type                     = "ingress"
      to_port                  = 0
      from_port                = 0
      protocol                 = "-1"
      source_security_group_id = aws_security_group.alb_sg_cluster.id
      description              = "allow inbound networking from ALB"
    }
  }
  tags = {
    Name = "Weathers_project"
  }
}