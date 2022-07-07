---
apiVersion: v1
kind: Secret
metadata:
  name: aws-secret
  namespace: ${namespace}
type: Opaque
data:
  AWS_ACCESS_KEY_ID: ${aws-access-key-id}
  AWS_SECRET_ACCESS_KEY: ${aws-secret-access-key}
