variable "profile" {
  type        = string
  default     = ""
  description = "The profile name used."
}

variable "region" {
  type        = string
  default     = ""
  description = "The AWS region to be used."
}

variable "ami_id" {
  type        = string
  default     = ""
  description = "AMI id. Look up using the region. (default: us-east-1 ubuntu 20.04)"
}

variable "key_name" {
  type        = string
  description = "The key to use for ec2 instances"
}
