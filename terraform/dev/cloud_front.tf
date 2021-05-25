resource "aws_cloudfront_distribution" "cdn_distribution" {
  comment = "cloudfront-${var.service_name}-${var.service_stage}"

  origin {
    domain_name = aws_s3_bucket.s3_website_data.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.s3_website_data.bucket}"
  }

  # aliases = [var.cloudfront_domain_alias]

  # By default, show index.html file
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true

  # If there is a 404, return index.html with a HTTP 200 Response
  custom_error_response {
    error_caching_min_ttl = 5
    error_code            = 403
    response_code         = 404
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.s3_website_data.bucket}"

    # Forward all query strings, cookies and headers
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  # Distributes content to US and Europe
  price_class = "PriceClass_All"

  # Restricts who is able to access this content
  restrictions {
    geo_restriction {
      # type of restriction, blacklist, whitelist or none
      restriction_type = "none"
    }
  }

  # SSL certificate for the service.
  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn            = var.cloudfront_certificatw_arn
    # ssl_support_method             = "sni-only"
    # minimum_protocol_version       = "TLSv1.2_2019"
  }
}
