# VPC Module
module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr_block = var.vpc_cidr_block
}


# Staging Area Module
module "staging_area" {
  source = "./modules/staging_area"
  project_name = var.project_name
  environment = var.environment
}


# Airbyte Module
module "airbyte" {
  source = "./modules/airbyte"
  project_name = var.project_name
  environment  = var.environment
  instance_type = var.instance_type
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  allow_ips = var.allow_ips
  staging_area_bucket_arn = module.staging_area.staging_area_bucket_arn
  default_user = var.default_user
}
