resource "helm_release" "longhorn" {
  name       = var.name
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = var.helm_chart_version
  namespace  = var.namespace
  timeout    = 600

  set {
    name  = "defaultSettings.backupTarget"
    value = var.backup_location
  }

  set {
    name  = "defaultSettings.backupTargetCredentialSecret"
    value = kubernetes_secret.aws_secret[0] != null ? kubernetes_secret.aws_secret[0].metadata[0].name : ""
  }

  depends_on = [
    kubernetes_namespace.longhorn,
  ]
}
