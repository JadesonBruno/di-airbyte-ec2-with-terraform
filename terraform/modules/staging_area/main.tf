data "aws_caller_identity" "current" {}


resource "aws_s3_bucket" "staging" {
  bucket = "${var.project_name}-${var.environment}-staging-area-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Name = "${var.project_name}-${var.environment}-staging-area"
    Project = var.project_name
    Environment = var.environment
    Service = "staging-area"
    Terraform = "true"
  }
}


resource "aws_s3_bucket_public_access_block" "staging_area" {
  bucket = aws_s3_bucket.staging.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "staging_area" {
  bucket = aws_s3_bucket.staging.id

  versioning_configuration {
    status = "Enabled"
  }
}
