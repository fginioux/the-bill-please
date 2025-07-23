provider "aws" {
  region = var.region
}

# Security Group Bastion
resource "aws_security_group" "bastion_iac" {
  name        = "bastion-iac"
  description = "Security group bastion"

  ingress {
    description = "SSH open for all"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Bastion EC2
resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.bastion_iac.name]
  key_name      = var.key_name
  tags = {
    Name = "bastion-iac"
  }
}

# Security group for API Server
resource "aws_security_group" "api_server_iac" {
  name        = "api-server-iac"
  description = "Security group API Server"
  depends_on = [aws_instance.bastion]

  ingress {
    description = "SSH from bastion only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_instance.bastion.public_ip + "/32"]
  }

  ingress {
    description = "API port 8081 open for all"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Server API Instance
resource "aws_instance" "api_server" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.api_server_iac.name]
  key_name      = var.key_name
  tags = {
    Name = "api-server-iac"
  }
}