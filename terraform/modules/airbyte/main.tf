# Data source para AMI mais recente do Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}


# Key Pair para SSH (gera chave automaticamente)
resource "tls_private_key" "airbyte_tls_private_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}


resource "aws_key_pair" "airbyte_key_pair" {
  key_name   = "${var.project_name}-${var.environment}-airbyte-key"
  public_key = tls_private_key.airbyte_tls_private_key.public_key_openssh

  tags = {
    Name = "${var.project_name}-${var.environment}-airbyte-key"
    Project = var.project_name
    Environment = var.environment
    Service = "airbyte"
    Terraform = "true"
  }
}


# Resource for the EC2 instance
resource "aws_instance" "airbyte-ec2" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = aws_key_pair.airbyte_key_pair.key_name
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.airbyte.id]
  iam_instance_profile = aws_iam_instance_profile.airbyte.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
    encrypted = true

    tags = {
      Name = "${var.project_name}-${var.environment}-airbyte-root-volume"
      Project = var.project_name
      Environment = var.environment
      Service = "airbyte"
      Terraform = "true"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-airbyte-ec2"
    Project = var.project_name
    Environment = var.environment
    Service = "airbyte"
    Terraform = "true"
  }
}
