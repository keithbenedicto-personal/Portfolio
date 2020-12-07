variable "project_name" {}
variable "env" {}
variable "aws_account_id" {}
variable "aws_region" {}
variable "iam_role" {}
variable "tag_business_region" {}
variable "tag_business_unit" {}
variable "tag_client" {}
variable "tag_environment" {}
variable "tag_platform" {}
variable "tag_resource_created_by" {}
variable "cognito_saml_file" {}
variable "cognito_idenpool_prefix" {}
variable "cognito_callback_urls" {}
variable "cognito_logout_urls" {}
variable "he_optus_r53" {}
variable "horizon_engage_r53" {}
variable "depends_on_resource" {
    type = "string"
    default = ""
}

locals {
  iam_saml_provider = "arn:aws:iam::${var.aws_account_id}:saml-provider/PF"
}