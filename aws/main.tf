terraform {
  required_providers {
    aws = "~> 5.42.0"
  }

  backend "s3" {
    bucket         = "forum-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "forum-tf-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
