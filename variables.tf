variable "environment" {
  type = string
  description = "name of current environment"
}

variable "vpc_cidr" {
  type = string
  default = "10.120.0.0/16"
  description = "CIDR block of the environment"
}

variable "num_of_azs" {
  type = number
  default = 2
  description = "how many azs in our vpc"
}

variable "region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}
variable "eks_version" {
  type = string
  default = "1.33"
  description = "version of eks"
}
variable "eks_node_sizes" {
  type = list(string)
  description = "size of eks nodes"
}