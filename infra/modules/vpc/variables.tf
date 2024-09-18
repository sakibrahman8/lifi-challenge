variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "route_cidr_block" {
  description = "CIDR block for the route"
  type        = string
  default     = "0.0.0.0/0"
}
