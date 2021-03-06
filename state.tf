data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

variable "aws_region" {
  default = "eu-west-1"
}

variable "account_id" {
  default = "818032293643"
}

provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket         = "hm-terraform-state"
    region         = "eu-west-1"
    key="terraform.tfstate"
  }
}

