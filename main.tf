terraform {
  cloud {
    organization = "jtoh0227"
    workspaces {
      name = "cloud-workspace-test"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "aws_instance_test" {
  ami           = data.aws_ami.amazon_linux_2_ami.image_id
  instance_type = "t2.micro"
  tags = {
    Name = "terraform_created_instance"
  }
}

data "aws_ami" "amazon_linux_2_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230221.0-x86_64-gp2"]
  }
}
