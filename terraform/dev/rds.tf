resource "random_password" "password" {
  length = 15
  # special          = true
  # override_special = "/\"_%@ "
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier        = "db-${var.service_name}-${var.service_stage}"
  engine            = "postgres"
  engine_version    = "12.5"
  instance_class    = var.db_instance
  allocated_storage = var.db_memory
  storage_encrypted = var.db_encryption

  name                = var.db_name
  publicly_accessible = true

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = var.db_user
  password = random_password.password.result
  port     = var.db_port

  vpc_security_group_ids = [data.aws_security_group.default.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  # DB subnet group
  subnet_ids = module.vpc.public_subnets

  # DB parameter group
  family = "postgres12"

  # DB option group
  major_engine_version = "12"

  # Snapshot name upon DB deletion
  # final_snapshot_identifier = "demodb"

  # Database Deletion Protection
  deletion_protection = false
}

# Save parameters inside SSM for lambdas
resource "aws_ssm_parameter" "db_host" {
  name        = "/${var.service_name}-${var.service_stage}/database/address"
  description = "Endpoint for connect to database"
  type        = "SecureString"
  value       = module.db.this_db_instance_address
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/${var.service_name}-${var.service_stage}/database/name"
  description = "Database name"
  type        = "SecureString"
  value       = var.db_name
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/${var.service_name}-${var.service_stage}/database/username"
  description = "Username for database"
  type        = "SecureString"
  value       = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.service_name}-${var.service_stage}/database/password"
  description = "Password for database"
  type        = "SecureString"
  value       = random_password.password.result
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.service_name}-${var.service_stage}/database/port"
  description = "Port for database"
  type        = "SecureString"
  value       = var.db_port
}
