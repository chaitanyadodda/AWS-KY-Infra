terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
  access_key = "AKIAQUAYME7XIU5TKGMR"
  secret_key = "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"
}

