# IAM Role for Airbyte EC2 instance
resource "aws_iam_role" "airbyte" {
  name = "${var.project_name}-${var.environment}-airbyte-role"
  description = "IAM role for Airbyte EC2 instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "Name" = "${var.project_name}-${var.environment}-airbyte-role"
    "Project" = var.project_name
    "Environment" = var.environment
    "Service" = "airbyte"
    "Terraform" = "true"
  }
}


# IAM Policy for Airbyte EC2 instance
resource "aws_iam_policy" "airbyte" {
  name = "${var.project_name}-${var.environment}-airbyte-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          var.staging_area_bucket_arn,
          "${var.staging_area_bucket_arn}/*"
        ]
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-airbyte-policy"
    Project = var.project_name
    Environment = var.environment
    Service = "airbyte"
    Terraform = "true"
  }
}


# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "airbyte" {
  role = aws_iam_role.airbyte.name
  policy_arn = aws_iam_policy.airbyte.arn
}


# IAM Instance Profile for Airbyte EC2 instance
resource "aws_iam_instance_profile" "airbyte" {
    name = "${var.project_name}-${var.environment}-airbyte-instance-profile"
    role = aws_iam_role.airbyte.name

    tags = {
      Name = "${var.project_name}-${var.environment}-airbyte-instance-profile"
      Project = var.project_name
      Environment = var.environment
      Service = "airbyte"
      Terraform = "true"
    }
}
