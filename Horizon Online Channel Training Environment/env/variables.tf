variable "asurion_dns" {}
variable "aws_region" {}
variable "cognito_saml_file" {}
variable "description_default" {}
variable "platform" {}
variable "project_name" {}
variable "tag_business_region" {}
variable "tag_business_unit" {}
variable "tag_client" {}
variable "tag_platform" {}
variable "tag_resource_created_by" {}
variable "tag_scheduler" {}
variable "tag_email_distribution" {}
# Account/environment-specific Variables
variable "asurion_net_dns" {}
variable "asurion53_dns" {}
variable "aws_account_id" {}
variable "aws_profile" {}
variable "aws_subnet_1a_internal" {}
variable "aws_subnet_1c_internal" {}
variable "aws_subnet_1d_internal" {}
variable "aws_vpc" {}
variable "cognito_callback_urls" {}
variable "cognito_idenpool_prefix" {}
variable "cognito_logout_urls" {}
variable "env_version" {}
variable "env" {}
variable "iam_role" {}
variable "tag_environment" {}
variable "tag_friendly_environment" {}
variable "zone" {}

variable "iam_lambda_trust_relationship" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

# locals {
#   lb_subnets = ["${var.aws_subnet_1a_internal}", "${var.aws_subnet_1c_internal}"]
# }

# variable lb_subnets {
#   type = "list"
#   default = ["${var.aws_subnet_1a_internal}", "${var.aws_subnet_1c_internal}"]
# }

# CloudFront-specific Resources
# variable "ais_cf_bucket" {}