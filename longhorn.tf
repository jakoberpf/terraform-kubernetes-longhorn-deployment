resource "kubernetes_namespace" "longhorn" {
  metadata {
    annotations = {
      name = "longhorn-system"
    }

    labels = {
      managed-by = var.compartment
    }

    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.2.3"
  namespace  = "longhorn-system"

  depends_on = [
    kubernetes_namespace.longhorn,
  ]
}
