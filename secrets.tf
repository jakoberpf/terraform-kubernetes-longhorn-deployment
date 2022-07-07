data "kubectl_path_documents" "aws_secret" {
  count = var.aws_access_key_id != "" ? 1 : 0

  pattern = "${path.module}/kubernetes/aws.secret.tpl"

  vars = {
    namespace = var.namespace
  }

  sensitive_vars = {
    aws-access-key-id = base64encode(var.aws_access_key_id),
    aws-secret-access-key = base64encode(var.aws_secret_access_key)
  }

  depends_on = [
    helm_release.longhorn,
  ]
}

resource "kubectl_manifest" "aws_secret" {
  count = var.aws_access_key_id != "" ? 1 : 0

  yaml_body = data.kubectl_path_documents.aws_secret[0].documents[0]

  sensitive_fields = [
      "data.AWS_ACCESS_KEY_ID",
      "data.AWS_SECRET_ACCESS_KEY"
  ]
}