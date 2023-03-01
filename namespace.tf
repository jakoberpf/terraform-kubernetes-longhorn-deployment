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
