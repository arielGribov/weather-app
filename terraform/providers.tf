terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_id.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_id.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_auth.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_id.id]
    command     = "aws"
  }
}
provider "kubectl" {
  token                  = data.aws_eks_cluster_auth.eks_auth.token
  host                   = data.aws_eks_cluster.eks_id.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_id.certificate_authority[0].data)
  load_config_file       = false
}
