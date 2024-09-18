output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "ec2_instance_ids" {
  description = "The EC2 instance IDs"
  value       = module.ec2.instance_ids
}
