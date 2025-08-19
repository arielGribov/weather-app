
data "aws_eks_cluster" "eks_id" {
  depends_on = [module.eks]
  name       = var.eks_name
}

data "aws_eks_cluster_auth" "eks_auth" {
  depends_on = [module.eks]
  name       = var.eks_name
}


resource "kubernetes_namespace" "kube-namespace" {
  depends_on = [module.eks]
  metadata {
    name = "monitoring"
  }
}
resource "helm_release" "prometheus" {
  depends_on       = [kubernetes_namespace.kube-namespace]
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.kube-namespace.metadata[0].name
  create_namespace = false
  values           = [file("yamls/kube-prom-values.yaml")]
}
