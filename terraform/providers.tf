# Terraform configuration for AWS provider and S3 backend
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "di-terraform-states-767397903600"
    key    = "airbyte-aws-dev/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
  }
}


# AWS Provider
provider "aws" {
  region = var.aws_region
}
