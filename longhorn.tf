resource "helm_release" "longhorn" {
  name       = var.name
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = var.helm_chart_version
  namespace  = var.namespace
  timeout    = 600

  depends_on = [
    kubernetes_namespace.longhorn,
  ]
}
