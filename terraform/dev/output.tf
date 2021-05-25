# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# Internet gateways
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

# NAT gateways
output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.nat_ids
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC endpoints
output "vpc_endpoint_ssm_id" {
  description = "The ID of VPC endpoint for SSM"
  value       = module.vpc.vpc_endpoint_ssm_id
}

output "vpc_endpoint_ssm_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SSM."
  value       = module.vpc.vpc_endpoint_ssm_network_interface_ids
}

output "vpc_endpoint_ssm_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SSM."
  value       = module.vpc.vpc_endpoint_ssm_dns_entry
}

output "vpc_endpoint_lambda_id" {
  description = "The ID of VPC endpoint for Lambda"
  value       = module.vpc.vpc_endpoint_lambda_id
}

output "vpc_endpoint_lambda_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Lambda."
  value       = module.vpc.vpc_endpoint_lambda_network_interface_ids
}

output "vpc_endpoint_lambda_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Lambda."
  value       = module.vpc.vpc_endpoint_lambda_dns_entry
}

# RDS
output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.this_db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db.this_db_instance_arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db.this_db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.this_db_instance_endpoint
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db.this_db_instance_hosted_zone_id
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.this_db_instance_id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db.this_db_instance_resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.db.this_db_instance_status
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db.this_db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.db.this_db_instance_username
}

# output "db_instance_password" {
#   description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
#   value       = module.db.this_db_instance_password
# }

output "db_instance_port" {
  description = "The database port"
  value       = module.db.this_db_instance_port
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db.this_db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db.this_db_subnet_group_arn
}

output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db.this_db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db.this_db_parameter_group_arn
}
