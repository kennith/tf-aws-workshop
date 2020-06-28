variable "profile" {
    type = string
    description = "The profile name used."
}

variable "region" {
    type = string
    default = "us-east-1"
    description = "The AWS region to be used."
}

variable "ami_id" {
    type = string
    description = "AMI id. Look up using the region."
}