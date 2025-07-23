variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "ami" {
  description = "Instances EC2 AMI ID"
  type        = string
  default     = "ami-02003f9f0fde924ea"
}

variable "instance_type" {
  description = "EC2 Instances Type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name to access Ec2"
  type        = string
  default     = "aws-ec2"
}
