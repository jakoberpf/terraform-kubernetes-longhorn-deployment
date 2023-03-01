resource "kubernetes_secret" "aws_secret" {
  count = var.aws_access_key_id != "" ? 1 : 0
  metadata {
    name      = "aws-secret"
    namespace = var.namespace
  }
  data = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  }
}
