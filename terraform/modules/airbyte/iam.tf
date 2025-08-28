resource "aws_iam_role" "airbyte" {
  name = "${var.project_name}-${var.environment}-airbyte-role"
  description = "IAM role for Airbyte EC2 instance"

  assume_role_policy = jsondecode({
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


resource "aws_iam_role_policy" "airbyte" {
  name = "${var.project_name}-${var.environment}-airbyte-policy"
  role = aws_iam_role.airbyte.id

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
          "arn:aws:s3:::${aws_s3_bucket.staging.id}",
          "arn:aws:s3:::${aws_s3_bucket.staging.id}/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "airbyte" {
  role = aws_iam_role.airbyte.id
  policy_arn = aws_iam_role_policy.airbyte.arn
}


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
