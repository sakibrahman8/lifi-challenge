aws_region = "eu-west-2"
vpc_cidr = "10.0.0.0/16"
public_subnet = "10.0.1.0/24"
route_cidr_block = "0.0.0.0/0"
security_group_ingress = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Normally would limit this
  },
  {
    from_port   = 4201
    to_port     = 4201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Again normally would limit this
  }
]
security_group_egress = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
instance_type = "t2.medium"
ami = "ami-01ec84b284795cbc7"
instance_tags = {
  Name = "BirdApp"
}
key_name = "lifi"
