# Wrapper root module (this lab's own file, not upstream's): applies a small, cheap subset of
# sadcloud's modules (app/modules/aws/*, unchanged) with the findings chosen one by one, where
# upstream's root (app/sadcloud) only switches whole services on. Left out on purpose: the account
# password policy (an account-wide setting, which destroy would delete), world-open SNS topic, SQS
# queue and S3 buckets (anyone could use them while the lab runs), and every billed-by-the-hour
# service (EC2, RDS, Redshift, EKS, ELB, Elasticsearch).
terraform {
  required_version = ">= 1.5"
  required_providers {
    # sadcloud's S3 module sets the bucket's ACL and versioning inline, which the AWS provider
    # deprecated in v4 and still accepts in v5.
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = { "isoloom-environment" = "sadcloud", "managed-by" = "isoloom" }
  }
}

data "aws_caller_identity" "current" {}

module "iam" {
  source = "./modules/iam"

  inline_role_policy            = true
  inline_group_policy           = true
  inline_user_policy            = true
  assume_role_policy_allows_all = true
  admin_iam_policy              = true
  admin_not_indicated_policy    = true
}

module "s3" {
  source = "./modules/s3"

  no_default_encryption = true
  no_logging            = true
  no_versioning         = true
}

module "sqs" {
  source = "./modules/sqs"

  sqs_server_side_encryption_disabled = true
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "bucket" {
  value = module.s3.bucket_id
}
