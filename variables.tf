# Global
variable "name" {
  type        = string
  description = "The name of the deployment."
  default     = "longhorn"
}

variable "compartment" {
  type        = string
  description = "The compartment the ressource is deployed with."
}

# Ingress
variable "ingress_dns" {
  type        = string
  description = "The domain name where longhorn should be reachable."
}

# Gatekeeper
variable "gatekeeper_client_id" {
  type        = string
  description = "The client ID of the longhorn client."
}

variable "gatekeeper_client_secret" {
  type        = string
  description = "The client secret of the longhorn client."
}

variable "gatekeeper_encryption_key" {
  type        = string
  description = "The encryption key. If unset, the key will be generated by terraform."
}

variable "gatekeeper_redirection_url" {
  type        = string
  description = "The url where longhorn should be reachable."
}

variable "gatekeeper_discovery_url" {
  type        = string
  description = "The url of the keycloak iam provider"
}
