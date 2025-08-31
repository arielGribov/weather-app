terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = var.eks_name.eks_id.endpoint
  # cluster_ca_certificate = file("${path.module}/combined_ca.pem")

  cluster_ca_certificate = base64decode(var.eks_name.eks_id.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_auth.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_name.eks_id.id]
    command     = "aws"
  }
}
provider "kubectl" {
  token                  = data.aws_eks_cluster_auth.eks_auth.token
  host                   = var.eks_name.eks_id.endpoint
  cluster_ca_certificate = base64decode(var.eks_name.eks_id.certificate_authority[0].data)
  load_config_file       = false
}