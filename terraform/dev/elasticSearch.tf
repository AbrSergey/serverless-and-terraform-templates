resource "random_password" "es_password" {
  length = 15
  # special          = true
  # override_special = "/\"_%@ "
}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_resource_policy" "your-table" {
  policy_name = "${var.es_domain}-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_cloudwatch_log_group" "your-table" {
  name = "${var.es_domain}-log"
}

resource "aws_elasticsearch_domain" "your-table" {
  domain_name           = var.es_domain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.your-table.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.es_username
      master_user_password = random_password.es_password.result
    }
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${var.service_region}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
    }
  ]
}
POLICY
}

resource "aws_ssm_parameter" "es_username" {
  name        = "/${var.service_name}-${var.service_stage}/es/username"
  description = "Username for ES"
  type        = "SecureString"
  value       = var.es_username
}

resource "aws_ssm_parameter" "es_password" {
  name        = "/${var.service_name}-${var.service_stage}/es/password"
  description = "Password for ES"
  type        = "SecureString"
  value       = random_password.es_password.result
}

resource "aws_ssm_parameter" "es_host" {
  name        = "/${var.service_name}-${var.service_stage}/es/endpoint"
  description = "Endpoint for connect to es"
  type        = "SecureString"
  value       = "https://${aws_elasticsearch_domain.your-table.endpoint}"
}

resource "aws_ssm_parameter" "es_domain" {
  name        = "/${var.service_name}-${var.service_stage}/es/domain"
  description = "Endpoint for connect to es"
  type        = "SecureString"
  value       = aws_elasticsearch_domain.your-table.domain_name
}
