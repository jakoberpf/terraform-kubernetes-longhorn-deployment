# terraform-module-kubernetes-longhorn-deployment

This module manages the distributed storage longhorn deployment.

## TODOs

- add Python script to set the backup target https://longhorn.io/docs/1.3.0/references/longhorn-client-python/

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.longhorn](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.certificate](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.istio_gateway](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.istio_virtual_service](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.oauth2_proxy_configmap](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.oauth2_proxy_deployment](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.oauth2_proxy_service](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.traefik_ingress_route](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.longhorn](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.aws_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_string.deployment_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key_id"></a> [aws\_access\_key\_id](#input\_aws\_access\_key\_id) | The AWS\_ACCESS\_KEY\_ID for the S3 Backup Bucket | `string` | `""` | no |
| <a name="input_aws_secret_access_key"></a> [aws\_secret\_access\_key](#input\_aws\_secret\_access\_key) | The AWS\_SECRET\_ACCESS\_KEY for the S3 Backup Bucket. | `string` | `""` | no |
| <a name="input_compartment"></a> [compartment](#input\_compartment) | The compartment the ressource is deployed with. | `string` | n/a | yes |
| <a name="input_gatekeeper_client_id"></a> [gatekeeper\_client\_id](#input\_gatekeeper\_client\_id) | The client ID of the longhorn client. | `string` | n/a | yes |
| <a name="input_gatekeeper_client_secret"></a> [gatekeeper\_client\_secret](#input\_gatekeeper\_client\_secret) | The client secret of the longhorn client. | `string` | n/a | yes |
| <a name="input_gatekeeper_discovery_url"></a> [gatekeeper\_discovery\_url](#input\_gatekeeper\_discovery\_url) | The url of the keycloak iam provider | `string` | n/a | yes |
| <a name="input_gatekeeper_encryption_key"></a> [gatekeeper\_encryption\_key](#input\_gatekeeper\_encryption\_key) | The encryption key. If unset, the key will be generated by terraform. | `string` | n/a | yes |
| <a name="input_gatekeeper_redirection_url"></a> [gatekeeper\_redirection\_url](#input\_gatekeeper\_redirection\_url) | The url where longhorn should be reachable. | `string` | n/a | yes |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Helm | `string` | `"1.4.0"` | no |
| <a name="input_ingress_dns"></a> [ingress\_dns](#input\_ingress\_dns) | The domain name where longhorn should be reachable. | `string` | n/a | yes |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Exposes the Longhorn UI | `bool` | `false` | no |
| <a name="input_ingress_type"></a> [ingress\_type](#input\_ingress\_type) | The ingress type. Can be either 'traefik', 'istio' or 'none' | `string` | `"none"` | no |
| <a name="input_issuer_name"></a> [issuer\_name](#input\_issuer\_name) | The certifictae issuer name. | `string` | `"cloudflare-letsencrypt-staging"` | no |
| <a name="input_issuer_type"></a> [issuer\_type](#input\_issuer\_type) | The certifictae issuer type. | `string` | `"ClusterIssuer"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the deployment. | `string` | `"longhorn"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace of the deployment. | `string` | `"longhorn-system"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->