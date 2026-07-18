variable "aws_region" {
  type        = string
  description = "AWS Region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr" {
  type        = string
  description = "CIDR block for public subnet in AZ1"
  default     = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr" {
  type        = string
  description = "CIDR block for public subnet in AZ2"
  default     = "10.0.2.0/24"
}

variable "private_subnet_az1_cidr" {
  type        = string
  description = "CIDR block for private subnet in AZ1"
  default     = "10.0.11.0/24"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance type"
  default     = "t2.micro"
}

variable "admin_email" {
  type        = string
  description = "Email address for receiving CloudWatch SNS alerts"
}