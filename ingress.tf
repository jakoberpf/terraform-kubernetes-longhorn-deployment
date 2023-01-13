resource "kubectl_manifest" "traefik_ingress_route" {
  count     = var.ingress_type == "traefik" ? 1 : 0
  yaml_body = <<-EOF
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: longhorn-dashboard
  namespace: ${var.namespace}
spec:
  entryPoints:
    - websecure
  tls:
    secretName: ${replace(var.ingress_dns, ".", "-")}-tls
  routes:
    - match: Host(`${var.ingress_dns}`)
      kind: Rule
      services:
        - name: longhorn-gatekeeper
          port: 80
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn,
    kubectl_manifest.certificate
  ]
}

resource "kubectl_manifest" "istio_gateway" {
  count     = var.ingress_type == "istio" ? 1 : 0
  yaml_body = <<-EOF
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: longhorn-dashboard
  namespace: ${var.namespace}
spec:
  selector:
    istio: ingressgateway
  servers:
    - port:
        number: 80
        name: http
        protocol: HTTP
      hosts:
        - ${var.ingress_dns}
      tls:
        httpsRedirect: true
    - port:
        number: 443
        name: https
        protocol: HTTPS
      tls:
        mode: "SIMPLE"
        credentialName: ${replace(var.ingress_dns, ".", "-")}-tls
      hosts:
        - ${var.ingress_dns}
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn,
    kubectl_manifest.certificate
  ]
}

resource "kubectl_manifest" "istio_virtual_service" {
  count     = var.ingress_type == "istio" ? 1 : 0
  yaml_body = <<-EOF
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: longhorn-dashboard
  namespace: ${var.namespace} 
spec:
  hosts:
    - ${var.ingress_dns}
  gateways:
    - longhorn-dashboard
  http:
    - match:
      - uri:
          prefix: /
      route:
      - destination:
          port:
            number: 443
          host: longhorn-gatekeeper
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
  namespace: ${var.namespace}
spec:
  secretName: ${replace(var.ingress_dns, ".", "-")}-tls
  issuerRef:
    name: ${var.issuer_name}
    kind: ${var.issuer_type}
  commonName: ${var.ingress_dns}
  dnsNames:
  - "${var.ingress_dns}"
  secretTemplate:
    annotations:
      reflector.v1.k8s.emberstack.com/reflection-allowed: "true"  
      reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces: "istio-system"
      reflector.v1.k8s.emberstack.com/reflection-auto-enabled: "true"
      reflector.v1.k8s.emberstack.com/reflection-auto-namespaces: "istio-system"
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}
