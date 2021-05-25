resource "aws_cognito_user_pool" "pool" {
  name = "pool-${var.service_name}-${var.service_stage}"
  username_configuration {
    case_sensitive = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}. "
      email_subject = "Your temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}. "
    }
  }

  username_attributes = ["phone_number"]

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = var.auth_domain
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "client-tf-${var.service_stage}"
  user_pool_id                         = aws_cognito_user_pool.pool.id
  refresh_token_validity               = 1
  generate_secret                      = false
  prevent_user_existence_errors        = "ENABLED"
  callback_urls                        = ["http://localhost:3000/auth", var.auth_callback_url]
  logout_urls                          = ["http://localhost:3000/login"]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  supported_identity_providers         = ["COGNITO"]
}

# Save parameters inside SSM for lambdas
resource "aws_ssm_parameter" "cognito_pool_id" {
  name        = "/${var.service_name}-${var.service_stage}/cognito/pool/id"
  description = "Cognito user pool id"
  type        = "SecureString"
  value       = aws_cognito_user_pool.pool.id
}

resource "aws_ssm_parameter" "cognito_pool_domain" {
  name        = "/${var.service_name}-${var.service_stage}/cognito/pool/domain"
  description = "Cognito user pool endpoint"
  type        = "SecureString"
  value       = "https://${aws_cognito_user_pool_domain.domain.domain}.auth.us-east-1.amazoncognito.com"
}
