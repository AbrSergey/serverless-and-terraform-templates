/*
  After creation S3 bucket for static website you need follow stepd:
    - Go to S3 bucket of static website
    - Go to "Permissions" tab
    - Go to "Access control list (ACL)" and click to "Edit"
    - Turn off "Everyone (public access)"/"Objects" 
*/

resource "random_uuid" "uuid" {}

locals {
  prefix = substr(random_uuid.uuid.result, 0, 5)
}

resource "aws_s3_bucket" "s3_website_data" {
  bucket = "${var.service_name}-${var.service_stage}-website-${local.prefix}"
  acl    = "public-read"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["your-domain"] // change to actual domain
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  policy = replace(<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::YOURDOMAIN/*"
      }
  ]
}
EOF
  , "YOURDOMAIN", "${var.service_name}-${var.service_stage}-website-${local.prefix}")
}
