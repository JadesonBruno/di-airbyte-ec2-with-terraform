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


provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr_block = var.vpc_cidr_block
}


module "staging_area" {
  source = "./modules/staging_area"
  project_name = var.project_name
  environment = var.environment
}


module "airbyte" {
  source = "./modules/airbyte"
  project_name = var.project_name
  environment  = var.environment
  instance_type = var.instance_type
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  allow_ips = var.allow_ips
  staging_area_bucket_arn = module.staging_area.staging_area_bucket_arn
}
