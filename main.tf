provider "aws" {
  profile = var.profile
  region  = var.region
}

# networking.tf
# app.tf

# data {}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
