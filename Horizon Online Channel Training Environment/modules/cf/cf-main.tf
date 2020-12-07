provider "aws" {
  alias  = "module"
  region = "us-east-1"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

locals {
  # S3 Origin IDs
  singtel_s3_origin_id                = "S3-TF-${var.singtel_s3_bucket}"
  chat_engine_s3_origin_id            = "S3-TF-${var.chat_engine_s3_bucket}"
  ais_s3_origin_id                    = "S3-TF-${var.ais_s3_bucket}"
  starhub_s3_origin_id                = "S3-TF-${var.starhub_s3_bucket}"
  starhub_screenrepair_s3_origin_id   = "S3-TF-${var.starhub_screenrepair_s3_bucket}"
  starhub_dhc_s3_origin_id            = "S3-TF-${var.starhub_screenrepair_s3_bucket}"
  samsung_s3_origin_id                = "S3-TF-${var.samsung_s3_bucket}"
  m1_s3_origin_id                     = "S3-TF-${var.m1_s3_bucket}"
  celcom_s3_origin_id                 = "S3-TF-${var.celcom_s3_bucket}"
  engage_s3_origin_id                 = "S3-TF-${var.engage_s3_bucket}"
  optus_session_s3_origin_id          = "S3-TF-${var.optus_session_s3_bucket}"
  optus_booking_s3_origin_id          = "S3-TF-${var.optus_booking_s3_bucket}"
  he_s3_origin_id                     = "S3-TF-${var.he_s3_bucket}"

  # API Gateway Origin IDs
  ui_api_origin_id     = "Custom-TF-${var.project_name}-ui-api-${var.env}/${var.env}"
  twilio_api_origin_id = "Custom-TF-${var.project_name}-twilio-integrator-${var.env}/${var.env}"

  # Other Custom Origin IDs
  qbgw_custom_origin_id = "Custom-TF-qbgw.newcorp.com/web/service/processTransactionAPAC"
  qbgw_invoke_url       = "qbgw.newcorp.com"
  qbgw_path             = "/web/service/processTransactionAPAC"

  # API Gateways not created within Terraform
  sqa_ap_ol_origin_id  = "Custom-TF-sqa-ap-ol/sea-sqa1-apac" # !!
  sqa_ap_ol_invoke_url = "xfxpvdg9m3.execute-api.ap-northeast-1.amazonaws.com"
  sqa_ap_ol_path       = "/sea-sqa1-apac"

  # sqa-ap-private api gateway (r2evvrlkdj) --> not in terraform
  sqa_ap_private_origin_id  = "Custom-TF-sqa-ap-private/sea-sqa2-apac" # !!
  sqa_ap_private_invoke_url = "r2evvrlkdj.execute-api.ap-northeast-1.amazonaws.com"
  sqa_ap_private_path       = "/sea-sqa2-apac"

  # Associated Lambda Functions
  horizon_online_lambda_arn = "arn:aws:lambda:us-east-1:607516933194:function:Horizon-Online:3"
}

# Horizon Online Web (Singtel Online) CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "singtel_s3_oai" {
  comment = "${var.singtel_s3_bucket} Origin Access Identity created by Terraform"
}

# Horizon Chat Engine (Singtel Chat Engine) CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "chat_engine_s3_oai" {
  comment = "${var.chat_engine_s3_bucket} Origin Access Identity created by Terraform"
}

# AIS CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "ais_s3_oai" {
  comment = "${var.ais_s3_bucket} Origin Access Identity created by Terraform"
}

# Horizon Online Starhub (Starhub Online) CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "horizon_online_starhub_s3_oai" {
  comment = "${var.starhub_s3_bucket} Origin Access Identity created by Terraform"
}

# Starhub Screenrepair CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "starhub_screenrepair_s3_oai" {
  comment = "${var.starhub_screenrepair_s3_bucket} Origin Access Identity created by Terraform"
}

# Starhub DHC CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "starhub_dhc_s3_oai" {
  comment = "${var.starhub_dhc_s3_bucket} Origin Access Identity created by Terraform"
}

# Horizon Online Samsung CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "horizon_online_samsung_s3_oai" {
  comment = "${var.samsung_s3_bucket} Origin Access Idenetity created by Terraform" 
}

# M1 CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "m1_s3_oai" {
  comment = "${var.m1_s3_bucket} Origin Access Identity created by Terraform"
}

# Celcom CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "celcom_s3_oai" {
  comment = "${var.celcom_s3_bucket} Origin Access Identity created by Terraform"
}

# Horizon Online Engage CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "horizon_online_engage_s3_oai" {
  comment = "${var.engage_s3_bucket} Origin Access Idenetity created by Terraform" 
}

# Optus Session CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "optus_session_s3_oai" {
  comment = "${var.optus_session_s3_bucket} Origin Access Idenetity created by Terraform" # !!
}

# Optus Booking CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "optus_booking_s3_oai" {
  comment = "${var.optus_booking_s3_bucket} Origin Access Idenetity created by Terraform" # !!
}

# HE CloudFront S3 Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "he_s3_oai" {
  comment = "${var.he_s3_bucket} Origin Access Idenetity created by Terraform" # !!
}

#############################################################################################

resource "null_resource" "service_depends_on"{
  triggers = {
    deps = "${jsonencode(var.depends_on_resource)}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "singtel_chat_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-chatengine-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-chatengine-ol-${var.tag_environment}.${var.asurion53_dns}"]

  viewer_certificate {
    acm_certificate_arn = "${var.chat_engine_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.chat_engine_s3_domain_name}"
    origin_id   = "${local.chat_engine_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.chat_engine_s3_oai.cloudfront_access_identity_path}"
    }
  }

  # Behaviors
  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.chat_engine_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-singtel-chat-engine-cf-${var.env}-${var.env_version}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "singtel_online_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name}-singtel-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-singtel-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    # acm_certificate_arn = "${data.aws_acm_certificate.mobileswop_acm_cert.arn}"
    acm_certificate_arn = "${var.singtel_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.singtel_s3_domain_name}"
    origin_id   = "${local.singtel_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.singtel_s3_oai.cloudfront_access_identity_path}"
    }
  }

  origin { # API Gateway Custom Origin - UI API
    domain_name = "${var.ui_api_invoke_url}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "${local.ui_api_origin_id}"
    origin_path = "/${var.env}" # /dev, /sqa, etc.

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "https-only"
      origin_ssl_protocols      = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  ordered_cache_behavior { # Precedence 1
    path_pattern     = "api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.ui_api_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "https-only"
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.singtel_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 7200
    max_ttl     = 7200

    viewer_protocol_policy = "redirect-to-https"

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = "${local.horizon_online_lambda_arn}" # !!
      include_body = false
    }
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-singtel-${var.env}-online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "ais_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-ais-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-ais-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    acm_certificate_arn = "${var.ais_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.ais_s3_domain_name}"
    origin_id   = "${local.ais_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.ais_s3_oai.cloudfront_access_identity_path}"
    }
  }

  origin { # API Gateway Custom Origin - UI API
    domain_name = "${var.ui_api_invoke_url}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "${local.ui_api_origin_id}"
    origin_path = "/${var.env}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "https-only"
      origin_ssl_protocols      = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  origin { # API Gateway Custom Origin - sqa-ap-ol
    domain_name = "${local.sqa_ap_ol_invoke_url}" # !!
    origin_id   = "${local.sqa_ap_ol_origin_id}"
    origin_path = "${local.sqa_ap_ol_path}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "http-only"
      origin_ssl_protocols      = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  # Behaviors
  ordered_cache_behavior { # Precedence 0
    path_pattern     = "api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.ui_api_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 1
    path_pattern     = "api/corewrapper/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_ol_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 1

    viewer_protocol_policy = "https-only"
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.ais_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-mobilecare-ais-${var.env}-online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "m1_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-m1-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-m1-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    acm_certificate_arn = "${var.m1_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.m1_s3_domain_name}"
    origin_id   = "${local.m1_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.m1_s3_oai.cloudfront_access_identity_path}"
    }
  }

  origin { # API Gateway Custom Origin - UI API
    domain_name = "${var.ui_api_invoke_url}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "${local.ui_api_origin_id}"
    origin_path = "/${var.env}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "https-only"
      origin_ssl_protocols      = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  origin { # API Gateway Custom Origin - sqa-ap-ol (xfxpvdg9m3) --> not created in terraform
    domain_name = "${local.sqa_ap_ol_invoke_url}"
    origin_id   = "${local.sqa_ap_ol_origin_id}"
    origin_path = "${local.sqa_ap_ol_path}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "https-only"
      origin_ssl_protocols      = ["TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  origin { # Custom Origin - qbgw.newcorp.com
    domain_name = "${local.qbgw_invoke_url}"
    origin_id   = "${local.qbgw_custom_origin_id}"
    origin_path = "${local.qbgw_path}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "https-only"
      origin_ssl_protocols      = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_read_timeout       = 30
      origin_keepalive_timeout = 5
    }
  }

  # API Gateway Custom Origin - sqa-ap-private (r2evvrlkdj) --> not created in terraform
  origin {
    domain_name = "${local.sqa_ap_private_invoke_url}"
    origin_id   = "${local.sqa_ap_private_origin_id}"
    origin_path = "${local.sqa_ap_private_path}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "https-only"
      origin_ssl_protocols      = ["TLSv1.2"]
      origin_read_timeout       = 30
      origin_keepalive_timeout = 5
    }
  }

  # Behaviors
  ordered_cache_behavior { # Precedence 0
    path_pattern     = "api/incidentidentification/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_private_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 1
    path_pattern     = "api/physicalassetfulfillment/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_private_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 2
    path_pattern     = "api/servicerequest/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_private_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 3
    path_pattern     = "api/accountadministration/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_private_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 4
    path_pattern     = "api/caseadministration/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_private_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 5
    path_pattern     = "api/corewrapper/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_private_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 6
    path_pattern     = "api/subsystem/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_private_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 7
    path_pattern     = "api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.ui_api_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 8
    path_pattern     = "${local.qbgw_path}/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.qbgw_custom_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "https-only"
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.m1_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-m1-fonecare-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "starhub_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-starhub-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-starhub-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    # acm_certificate_arn = "${data.aws_acm_certificate.starhub_acm_cert.arn}"
    acm_certificate_arn = "${var.starhub_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.starhub_s3_domain_name}"
    origin_id   = "${local.starhub_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.horizon_online_starhub_s3_oai.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.starhub_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-starhub-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "starhub_screenrepair_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name}-starhubrepair-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-starhubrepair-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    acm_certificate_arn = "${var.starhub_screenrepair_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.starhub_screenrepair_s3_domain_name}"
    origin_id   = "${local.starhub_screenrepair_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.starhub_screenrepair_s3_oai.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.starhub_screenrepair_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-starhub-screenrepair-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "starhub_dhc_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-starhub-dhc-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-starhub-dhc-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    acm_certificate_arn = "${var.starhub_dhc_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.starhub_dhc_s3_domain_name}"
    origin_id   = "${local.starhub_dhc_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.starhub_dhc_s3_oai.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.starhub_dhc_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-starhub-dhc-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
 
#############################################################################################
#DONE
resource "aws_cloudfront_distribution" "samsung_au_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-samsung-au-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-samsung-au-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    # acm_certificate_arn = "${data.aws_acm_certificate.samsung_au_acm_cert.arn}"
    acm_certificate_arn = "${var.samsung_au_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin - horizon online samsung
    domain_name = "${var.samsung_s3_domain_name}"
    origin_id   = "${local.samsung_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.horizon_online_samsung_s3_oai.cloudfront_access_identity_path}"
    }
  }

  origin { # API Gateway Custom Origin - UI API
    domain_name = "${var.ui_api_invoke_url}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "${local.ui_api_origin_id}"
    origin_path = "/${var.env}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "https-only"
      origin_ssl_protocols      = ["TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  # Behaviors
  ordered_cache_behavior { # Precedence 0
    path_pattern     = "api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.ui_api_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "set-cookie", "x-api-key", "x-requested-with"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 1

    viewer_protocol_policy = "https-only"
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.samsung_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-samsung-au-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "horizon_engage_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-hrz-engage-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-hrz-engage-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {
    # acm_certificate_arn = "${data.aws_acm_certificate.horizon_engage_acm_cert.arn}"
    acm_certificate_arn = "${var.horizon_engage_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin
    domain_name = "${var.engage_s3_domain_name}"
    origin_id   = "${local.engage_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.horizon_online_engage_s3_oai.cloudfront_access_identity_path}"
    }
  }

  origin { # API Gateway Custom Origin - sqa-ap-ol (xfxpvdg9m3) --> not created in terraform
    domain_name = "${local.sqa_ap_ol_invoke_url}" # !!
    origin_id   = "${local.sqa_ap_ol_origin_id}"
    origin_path = "${local.sqa_ap_ol_path}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "http-only"
      origin_ssl_protocols      = ["TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  origin { # API Gateway Custom Origin - twilio integrator endpoint
    domain_name = "${var.twilio_endpoint_invoke_url}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "${local.twilio_api_origin_id}"
    origin_path = "/${var.env}"

    custom_origin_config {
      http_port                 = 80
      https_port                = 443
      origin_protocol_policy    = "http-only"
      origin_ssl_protocols      = ["TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  # Behaviors
  ordered_cache_behavior { # Precedence 0 - sqa-ap-ol (xfxpvdg9m3)
    path_pattern     = "api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_ol_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Authorization", "Cache-Control", "Content-Type", "Expires", "If-Modified-Since", "pragma", "x-api-key"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 1

    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior { # Precedence 1
    path_pattern     = "tw/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.sqa_ap_ol_origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Accept", "Access-Control-Allow-Origin", "Authorization", "Cache-Control", "Content-Type", "Expires", "Origin", "pragma", "x-api-key"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 1

    viewer_protocol_policy = "https-only"
  }

  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.engage_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 7200
    max_ttl     = 7200

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-horizon-engage-${var.env}.${var.asurion53_dns}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "celcom_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.project_name}-celcom-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["${var.project_name}-celcom-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {

    acm_certificate_arn = "${var.celcom_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin - celcom
    domain_name = "${var.celcom_s3_domain_name}"
    origin_id   = "${local.celcom_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.celcom_s3_oai.cloudfront_access_identity_path}"
    }
  }

  # Behaviors
  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.celcom_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-celcom-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "optus_session_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "anzhzn-optus-ol-session-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["anzhzn-optus-ol-session-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s # should be corrected in var.env!!

  viewer_certificate {

    acm_certificate_arn = "${var.optus_session_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin - optus session
    domain_name = "${var.optus_session_s3_domain_name}"
    origin_id   = "${local.optus_session_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.optus_session_s3_oai.cloudfront_access_identity_path}"
    }
  }

  # Behaviors
  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.optus_session_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-optus-session-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "optus_booking_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "anzhzn-optus-ol-booking-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["anzhzn-optus-ol-booking-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s


  

  viewer_certificate {

    acm_certificate_arn = "${var.optus_booking_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin - optus booking
    domain_name = "${var.optus_booking_s3_domain_name}"
    origin_id   = "${local.optus_booking_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.optus_booking_s3_oai.cloudfront_access_identity_path}"
    }
  }

  # Behaviors
  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.optus_booking_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-optus-booking-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#############################################################################################
#DONE#
resource "aws_cloudfront_distribution" "he_cf" {
  # General
  depends_on          = ["null_resource.service_depends_on"]
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "anzhzn-he-ol-${var.tag_environment}.${var.asurion53_dns}"
  default_root_object = "index.html"

  aliases = ["anzhzn-he-ol-${var.tag_environment}.${var.asurion53_dns}"] # CNAME/s

  viewer_certificate {

    acm_certificate_arn = "${var.he_acm_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  # Origins and Origin Groups
  origin { # S3 Origin - he
    domain_name = "${var.he_s3_domain_name}"
    origin_id   = "${local.he_s3_origin_id}" # Unique identifier for the origin

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.he_s3_oai.cloudfront_access_identity_path}"
    }
  }

  # Behaviors
  default_cache_behavior { # Default
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.he_s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-he-${var.env}.online.${var.asurion53_dns}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}


