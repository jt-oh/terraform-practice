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
  ami           = "ami-06ee4e2261a4dc5c3"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform_created_instance"
  }
}


