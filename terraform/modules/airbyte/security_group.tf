resource "aws_security_group" "airbyte" {
  name = "${var.project_name}-${var.environment}-airbyte-sg"
  description = "Security group for Airbyte EC2 instance"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow SSH access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allow_ips
  }

  ingress {
    description = "Allow Connections from on-premisse network to Airbyte Web UI"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allow_ips
  }

  ingress {
    description = "Allow ICMP ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allow_ips
  }

  ingress {
    description = "Allow Connections to Airbyte Web UI"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = var.allow_ips
  }

  ingress {
    description = "Allow Connections to Airbyte API"
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = var.allow_ips
  }

  ingress {
    description = "Allow Instance Connect"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids = ["pl-03915406641cb1f53"]
  }

  ingress {
    description = "Allow all traffic from same security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-airbyte-sg"
    Project = var.project_name
    Environment = var.environment
    Service = "airbyte"
    Terraform = "true"
  }
}
