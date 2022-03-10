resource "kubectl_manifest" "ingressroute" {
  yaml_body = <<-EOF
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: longhorn-dashboard
  namespace: longhorn-system
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`${var.ingress_dns}`) # Hostname to match
      kind: Rule
      services: # Service to redirect requests to
        - name: longhorn-gatekeeper
          port: 80
  tls:
    secretName: ${replace(var.ingress_dns, ".", "-")}-tls
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn,
    kubectl_manifest.certificate
  ]
}

resource "kubectl_manifest" "certificate" {
  yaml_body = <<-EOF
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${replace(var.ingress_dns, ".", "-")}-tls
  namespace: longhorn-system
spec:
  secretName: ${replace(var.ingress_dns, ".", "-")}-tls
  issuerRef:
    name: cloudflare-letsencrypt-prod
    kind: ClusterIssuer
  commonName: ${var.ingress_dns}
  dnsNames:
  - "${var.ingress_dns}"
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}
