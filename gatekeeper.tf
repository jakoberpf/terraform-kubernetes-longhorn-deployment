resource "kubectl_manifest" "gatekeeper_deployment" {
  yaml_body = <<-EOF
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: longhorn-gatekeeper
  namespace: longhorn-system
spec:
  selector:
    matchLabels:
      app: longhorn-gatekeeper
  template:
    metadata:
      labels:
        app: longhorn-gatekeeper
    spec:
      containers:
      - name: gatekeeper-sidecar
        image: carlosedp/keycloak-gatekeeper
        imagePullPolicy: IfNotPresent
        ports:
          - name: gatekeeper
            containerPort: 3000
        args:
          - --client-id=${var.gatekeeper_client_id}
          - --client-secret=${var.gatekeeper_client_secret}
          - --encryption-key=${var.gatekeeper_encryption_key}
          - --upstream-url=http://longhorn-frontend.longhorn-system.svc.cluster.local:80
          - --redirection-url=${var.gatekeeper_redirection_url}
          - --discovery-url=${var.gatekeeper_discovery_url}
          - --listen=0.0.0.0:3000
          # - --secure-cookie=false
          # - --skip-upstream-tls-verify=false
          # - --skip-openid-provider-tls-verify=true
          # - --enable-logging=true
          # - --enable-json-logging=true
          # - --enable-default-deny=true
          # - --enable-refresh-tokens=true
          # - --enable-session-cookies=true
        # env:
        #   - name: PROXY_CLIENT_SECRET
        #     valueFrom:
        #       secretKeyRef:
        #         name: gatekeeper-secrets
        #         key: client-secret
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}

resource "kubectl_manifest" "gatekeeper_service" {
  yaml_body = <<-EOF
---
apiVersion: v1
kind: Service
metadata:
  name: longhorn-gatekeeper
  namespace: longhorn-system
  labels:
    app: longhorn-gatekeeper
spec:
  selector: 
    app: longhorn-gatekeeper
  ports:
  - name: http
    port: 80
    targetPort: 3000
EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}
