variable "name" {
  description = "Helm NAME"
  type        = string
}

variable "create_namespace" {
  description = "Create a Kubernetes namespace"
  type        = bool
  default     = false
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "chart_url" {
  description = "Helm Cahrt repository"
  type        = string
}

variable "chart_name" {
  description = "Helm Chart name"
  type        = string
}

variable "chart_version" {
  description = "Helm Chart version"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "set_values" {
  description = "set values"
  type        = set(object({
    name  = string
    value = string
    type  = string
  }))
}

variable "set_sensitive_values" {
  description = "set values"
  type        = set(object({
    name  = string
    value = string
    type  = string
  }))
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  type        = string
} 

variable "cluster_ca_cert" {
  description = "Kubernetes cluster cluster_ca_certificate"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Environment"
  type = string
}
