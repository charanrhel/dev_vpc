terraform {
  required_providers {
    aws = {
      region  = [us-east-2]
      source  = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}