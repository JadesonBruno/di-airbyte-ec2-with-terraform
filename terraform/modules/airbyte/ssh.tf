# Key Pair for SSH (generates key automatically)
resource "tls_private_key" "airbyte" {
  algorithm = "RSA"
  rsa_bits = 4096
}


# Public Key for EC2 instance
resource "aws_key_pair" "airbyte" {
  key_name   = "${var.project_name}-${var.environment}-airbyte-key"
  public_key = tls_private_key.airbyte.public_key_openssh

  tags = {
    Name = "${var.project_name}-${var.environment}-airbyte-key"
    Project = var.project_name
    Environment = var.environment
    Service = "airbyte"
    Terraform = "true"
  }
}


# Save private key locally
resource "local_file" "private_key" {
  content = tls_private_key.airbyte.private_key_openssh
  filename = "${path.module}/keys/${var.project_name}-${var.environment}-airbyte-private-key.pem"
  file_permission = "0400"
}


# Save public key locally
resource "local_file" "public_key" {
  content = tls_private_key.airbyte.public_key_openssh
  filename = "${path.module}/keys/${var.project_name}-${var.environment}-airbyte-public-key.pub"
  file_permission = "0400"
}
