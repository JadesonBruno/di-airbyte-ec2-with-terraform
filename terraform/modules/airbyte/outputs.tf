# IAM Instance Profile
output "airbyte_instance_profile" {
  value = aws_iam_instance_profile.airbyte.id
}

# Public DNS
output "airbyte_public_dns" {
  value = aws_instance.airbyte-ec2.public_dns
}
