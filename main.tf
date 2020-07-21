variable "aws_region" {
  type        = string
}

variable "aws_access_key" {
  type        = string
}

variable "aws_secret_key" {
  type        = string
}

variable "project_name" {
  default = "project-compose-ami"
}


provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deploy" {
  key_name   = var.project_name
  public_key = tls_private_key.example.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

resource "aws_security_group" "main" {}
#  egress = [
#    {
#      cidr_blocks      = [ "0.0.0.0/0", ]
#      description      = ""
#      from_port        = 0
#      ipv6_cidr_blocks = []
#      prefix_list_ids  = []
#      protocol         = "-1"
#      security_groups  = []
#      self             = false
#      to_port          = 0
#    }
#  ]
# ingress                = [
#   {
#     cidr_blocks      = [ "0.0.0.0/0", ]
#     description      = ""
#     from_port        = 22
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = false
#     to_port          = 22
#  },
#   {
#     cidr_blocks      = [ "0.0.0.0/0", ]
#     description      = ""
#     from_port        = 5000
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = false
#     to_port          = 5000
#  }
#  ]
# }

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deploy.key_name

  tags = {
    Purpose = "for prototype of docker-compose and ami"
  }

  vpc_security_group_ids = [aws_security_group.main.id]
}
