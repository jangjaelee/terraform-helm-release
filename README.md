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

  cluster_name = local.cluster_name 


  env = "dev"
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
  version = ">= 3.2.0"
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
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}
```

terraform.tf
```hcl
terraform {
  required_version = ">= 0.13.0"

  backend "s3" {
    bucket = "kubesphere-terraform-state-backend"
    key = "kubesphere/helm-alb-controller/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "kubesphere-terraform-state-locks"
    encrypt = true
    profile = "eks_service"
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
```
