resource "kubernetes_namespace" "longhorn" {
  metadata {
    annotations = {
      name = var.namespace
    }

    labels = {
      managed-by = var.compartment
    }

    name = var.namespace
  }
}

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
