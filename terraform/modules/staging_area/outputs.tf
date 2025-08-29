output "staging_area_bucket_arn" {
  description = "The ARN of the S3 bucket used as staging area"
  value = aws_s3_bucket.staging.arn
}
