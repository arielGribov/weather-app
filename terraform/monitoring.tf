# module "eks-prometheus" {
#   source  = "lablabs/eks-prometheus/aws"
#   version = "2.1.0"
# }

# resource "kubernetes_namespace" "monitoring" {
#   metadata {
#     name = "monitoring"
#   }
# }
# resource "helm_release" "kube_prometheus_stack" {
#   name             = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   namespace        = "monitoring"
#   version          = "76.2.2"
#   create_namespace = true

#   values = [
#     file("${path.module}/kube-prom-values.yaml")
#   ]
# }










# resource "kubernetes_namespace" "kube-namespace" {
#   depends_on = [module.eks]
#   metadata {
#     name = "monitoring"
#   }
# }
# resource "helm_release" "prometheus" {
#   depends_on       = [kubernetes_namespace.kube-namespace]
#   name             = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   namespace        = kubernetes_namespace.kube-namespace.metadata[0].name
#   create_namespace = false
#   values           = [file("kube-prom-values.yaml")]
# }
