variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
}

variable "public_subnet" {
  description = "Public subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the instance"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}