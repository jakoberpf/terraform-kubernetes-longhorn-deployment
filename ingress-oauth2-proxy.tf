resource "kubectl_manifest" "oauth2_proxy_deployment" {
  count     = var.ingress_enabled ? 1 : 0
  yaml_body = <<-EOF
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: longhorn-oauth2-proxy
  namespace: ${var.namespace}
spec:
  selector:
    matchLabels:
      app: longhorn-oauth2-proxy
  template:
    metadata:
      labels:
        app: longhorn-oauth2-proxy
    spec:
      containers:
        - name: oauth2-proxy
          image: bitnami/oauth2-proxy
          imagePullPolicy: IfNotPresent
          args:
            - --config=/etc/oauth2-proxy/oauth2-proxy.cfg
          ports:
            - name: http-auth-proxy
              containerPort: 4180
          volumeMounts:
            - name: oauth2-proxy-config
              mountPath: /etc/oauth2-proxy
      volumes:
        - name: oauth2-proxy-config
          configMap:
            defaultMode: 420
            name: longhorn-oauth2-proxy-config
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}

resource "kubectl_manifest" "oauth2_proxy_configmap" {
  count     = var.ingress_enabled ? 1 : 0
  yaml_body = <<-EOF
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: longhorn-oauth2-proxy-config
  namespace: ${var.namespace}
data:
  oauth2-proxy.cfg: |
    http_address="0.0.0.0:4180"
    cookie_secret="${var.gatekeeper_encryption_key}"
    email_domains=["erpf.de"]
    cookie_secure="false"
    upstreams="http://longhorn-frontend.${var.namespace}.svc.cluster.local:80"
    cookie_domains=[".erpf.de"] # Required so cookie can be read on all subdomains.
    whitelist_domains=[".erpf.de"] # Required to allow redirection back to original requested target.

    # keycloak provider
    client_secret="${var.gatekeeper_client_secret}"
    client_id="${var.gatekeeper_client_id}"
    redirect_url="${var.gatekeeper_redirection_url}/oauth2/callback"

    # in this case oauth2-proxy is going to visit
    oidc_issuer_url="${var.gatekeeper_discovery_url}"
    provider="oidc"
    provider_display_name="Keycloak"
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}

resource "kubectl_manifest" "oauth2_proxy_service" {
  count     = var.ingress_enabled ? 1 : 0
  yaml_body = <<-EOF
---
apiVersion: v1
kind: Service
metadata:
  name: longhorn-oauth2-proxy
  namespace: ${var.namespace}
  labels:
    app: longhorn-oauth2-proxy
spec:
  selector: 
    app: longhorn-oauth2-proxy
  ports:
  - name: http
    port: 80
    targetPort: 4180
  type: ClusterIP
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}
