# Helm release Terraform module

Terraform module which creates Helm chart release

These types of resources are supported:

* [Helm Release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)


## Usage
### Create Helm chart release

main.tf
```hcl
module "helm_release" {
  source = "git@github.com:jangjaelee/terraform-helm-release.git"

  cluster_name     = local.cluster_name
  name             = var.name
  create_namespace = var.create_namespace
  namespace        = var.namespace
  chart_url        = var.chart_url
  chart_name       = var.chart_name
  chart_version    = var.chart_version

  set_values           = var.set_values
  set_sensitive_values = var.set_sensitive_values

  cluster_endpoint = var.cluster_endpoint
  cluster_ca_cert  = var.cluster_ca_cert

  env = var.env
}
```

locals.tf
```hcl
locals {
  vpc_name         = "KubeSphere-dev"
  cluster_name     = "KubeSphere-v121-dev"
  cluster_version  = "1.21"
}
```

providers.tf
```hcl
provider "aws" {
  region = var.region
  allowed_account_ids = var.account_id
  profile = "eks_service"
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
      command     = "aws"
    }
  }
}
```

terraform.tf
```hcl
terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "kubesphere-terraform-state-backend"
    key = "kubesphere/helm-alb-controller/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "kubesphere-terraform-state-locks"
    encrypt = true
    profile = "eks_service"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.50.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = ">= 2.2.0"
    }
  }
}
```

variables.tf
```hcl
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "account_id" {
  description = "List of Allowed AWS account IDs"
  type        = list(string)
  default     = ["123456789012"]
}

variable "name" {}
variable "create_namespace" {}
variable "namespace" {}
variable "chart_url" {}
variable "chart_name" {}
variable "chart_version" {}
variable "set_values" {}
variable "set_sensitive_values" {}
variable "cluster_endpoint" {}
variable "cluster_ca_cert" {}
variable "env" {}
```

terraform.tfvars
```hcl
ame                  = "aws-load-balancer-controller"
create_namespace      = false
namespace             = "kube-system"
chart_url             = "https://aws.github.io/eks-charts"
chart_name            = "aws-load-balancer-controller"
chart_version         = "1.3.2"

set_values = [{
    name  = "clusterName"
    value = "KubeSphere-v121-dev"
    type  = "string"
},{
    name  = "serviceAccount.create"
    value = false
    type  = "auto"
},{
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
    type  = "string"
}]

set_sensitive_values = [{
    name  = ""
    value = ""
    type  = "auto"
}]

cluster_endpoint = "https://cluster.kubesphere.kr"
cluster_ca_cert  = "29obGQwTkpqbzB6dEwvZ05WeC9kCm5rSG11YjZ2NUNldXhVTjdaR0U2d1NqeU04MVNvc2hDdlFLWAotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="

env = "dev"
```
