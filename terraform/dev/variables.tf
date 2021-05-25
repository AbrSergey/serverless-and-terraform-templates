# Provider configration
variable "service_region" {
  description = "The deploy target region in AWS"
  default     = "us-east-1"
}

# Service configuration
variable "service_name" {
  description = "Name of service / application"
  default     = "your-app"
}

variable "service_stage" {
  description = "The stage/environment to deploy to. Suggest: `sandbox`, `development`, `staging`, `production`."
  default     = "dev"
}

# Network configurarion
variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.10.0.0/16"
}

variable "vpc_azs_a" {
  description = "VPC azs A"
  default     = "us-east-1a"
}

variable "vpc_azs_b" {
  description = "VPC azs B"
  default     = "us-east-1b"
}

variable "vpc_azs_c" {
  description = "VPC azs C"
  default     = "us-east-1c"
}

variable "private_subnet_cidr_a" {
  description = "CIDR for the private subnet A"
  default     = "10.10.0.0/20"
}

variable "private_subnet_cidr_b" {
  description = "CIDR for the private subnet B"
  default     = "10.10.16.0/20"
}

variable "private_subnet_cidr_c" {
  description = "CIDR for the private subnet C"
  default     = "10.10.32.0/20"
}

variable "public_subnet_cidr_a" {
  description = "CIDR for the public subnet A"
  default     = "10.10.48.0/20"
}

variable "public_subnet_cidr_b" {
  description = "CIDR for the public subnet B"
  default     = "10.10.64.0/20"
}

variable "public_subnet_cidr_c" {
  description = "CIDR for the public subnet C"
  default     = "10.10.80.0/20"
}

# Database configuration
variable "db_instance" {
  description = "Database instance"
  default     = "db.t3.micro"
}

variable "db_memory" {
  description = "Database memory"
  default     = 5
}

variable "db_encryption" {
  description = "Database encryption flag"
  default     = false
}

variable "db_name" {
  description = "Database name"
  default     = "db"
}

variable "db_port" {
  description = "Database port"
  default     = 5432
}
variable "db_user" {
  description = "Database username"
  default     = "admin"
}

# Dynamodb
variable "dynamodb_your-table_table" {
  description = "Name for dynamodb table"
  default     = "your-table"
}

# Cognito authitenticator configuration
variable "auth_callback_url" {
  description = "Callback url"
  default     = "https://your-app.cloudfront.net/auth"
}

variable "auth_domain" {
  description = "Domain name"
  default     = "dev"
}

# ElasticSearch
variable "es_domain" {
  description = "Domain name for ElasticSearch service"
  default     = "dev-your-table"
}

variable "es_username" {
  description = "Username for access to Kibana"
  default     = "admin"
}
