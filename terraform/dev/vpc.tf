locals {
  vpc_name = "vpc-${var.service_name}-${var.service_stage}"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs             = [var.vpc_azs_a, var.vpc_azs_b, var.vpc_azs_c]
  private_subnets = [var.private_subnet_cidr_a, var.private_subnet_cidr_b, var.private_subnet_cidr_c] # NAT gateway
  public_subnets  = [var.public_subnet_cidr_a, var.public_subnet_cidr_b, var.public_subnet_cidr_c]    # Internet gateway

  # Description: Should be true if you want to provision a single shared NAT Gateway across all of your private networks
  single_nat_gateway = true

  # Description: Should be true if you want to provision NAT Gateways for each of your private networks
  enable_nat_gateway = true

  # Description: Controls if an Internet Gateway is created for public subnets and the related routes that connect them.
  create_igw = true

  # Description: Should be true to enable DNS hostnames in the VPC
  enable_dns_hostnames = true

  # Description: Should be true to enable DNS support in the VPC
  enable_dns_support = true

  # Description: Should be true if you want to provision an api gateway endpoint to the VPC
  enable_apigw_endpoint              = true
  apigw_endpoint_private_dns_enabled = true
  apigw_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Description: Should be true if you want to provision a Lambda endpoint to the VPC
  enable_lambda_endpoint              = true
  lambda_endpoint_private_dns_enabled = true
  lambda_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Description: Should be true if you want to provision a CloudWatch Logs endpoint to the VPC
  enable_logs_endpoint              = false
  logs_endpoint_private_dns_enabled = true
  logs_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Description: Whether to enable S3 VPC Endpoint for public subnets
  enable_public_s3_endpoint = true

  # Description: Should be true if you want to provision an RDS endpoint to the VPC
  enable_rds_endpoint              = true
  rds_endpoint_private_dns_enabled = true
  rds_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  enable_ecr_api_endpoint              = true
  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Description: Should be true if you want to provision a SNS endpoint to the VPC
  enable_sns_endpoint              = true
  sns_endpoint_private_dns_enabled = true
  sns_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Description: Should be true if you want to provision an SSM endpoint to the VPC
  enable_ssm_endpoint              = true
  ssm_endpoint_private_dns_enabled = true
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group = true
  default_security_group_ingress = [{
    description = "ALL traffic TO everywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]

  default_security_group_egress = [{
    description = "ALL traffic TO everywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = false # Todos switch to false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  private_subnet_tags = {
    Name = "${local.vpc_name}-private-subnet"
  }

  public_subnet_tags = {
    Name = "${local.vpc_name}-public-subnet"
  }

  vpc_tags = {
    Name = local.vpc_name
  }

  igw_tags = {
    Name = "${local.vpc_name}-internet-gateway"
  }

  nat_gateway_tags = {
    Name = "${local.vpc_name}-nat-gateway"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.service_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.service_region}.s3"
  vpc_endpoint_type = "Gateway"
}

# Export parameters to AWS SSM service for lambdas
resource "aws_ssm_parameter" "private_subnet_cidr_a" {
  name        = "/${var.service_name}-${var.service_stage}/subnets/private/zona/a"
  description = "Private subnet in zone A"
  type        = "SecureString"
  value       = module.vpc.private_subnets[0]
}

resource "aws_ssm_parameter" "private_subnet_cidr_b" {
  name        = "/${var.service_name}-${var.service_stage}/subnets/private/zona/b"
  description = "Private subnet in zone B"
  type        = "SecureString"
  value       = module.vpc.private_subnets[1]
}

resource "aws_ssm_parameter" "private_subnet_cidr_c" {
  name        = "/${var.service_name}-${var.service_stage}/subnets/private/zona/c"
  description = "Private subnet in zone C"
  type        = "SecureString"
  value       = module.vpc.private_subnets[2]
}

resource "aws_ssm_parameter" "default_security_group" {
  name        = "/${var.service_name}-${var.service_stage}/security_group"
  description = "Default security group"
  type        = "SecureString"
  value       = data.aws_security_group.default.id
}
