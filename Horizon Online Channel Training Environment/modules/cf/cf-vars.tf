variable "asurion_dns" {}
variable "env" {}
variable "iam_role" {}
variable "project_name" {}
variable "asurion53_dns" {}
variable "tag_business_region" {}
variable "tag_business_unit" {}
variable "tag_client" {}
variable "tag_platform" {}
variable "tag_resource_created_by" {}
variable "asurion_net_dns" {}
variable "aws_region" {}
variable "tag_environment" {}
# Vars from API module
variable "ui_api_invoke_url" {}
variable "twilio_endpoint_invoke_url" {}

# Vars from S3 module
variable "ais_s3_bucket" {}
variable "ais_s3_domain_name" {}
variable "chat_engine_s3_bucket" {}
variable "chat_engine_s3_domain_name" {}
variable "m1_s3_bucket" {}
variable "m1_s3_domain_name" {}
variable "starhub_s3_bucket" {}
variable "starhub_s3_domain_name" {}
variable "starhub_screenrepair_s3_bucket" {}
variable "starhub_screenrepair_s3_domain_name" {}
variable "starhub_dhc_s3_bucket" {}
variable "starhub_dhc_s3_domain_name" {}
variable "samsung_s3_domain_name" {}
variable "samsung_s3_bucket" {}
variable "engage_s3_domain_name" {}
variable "engage_s3_bucket" {}
variable "singtel_s3_domain_name" {}
variable "singtel_s3_bucket" {}
variable "celcom_s3_domain_name" {}
variable "celcom_s3_bucket" {}
variable "he_s3_domain_name" {}
variable "he_s3_bucket" {}
variable "optus_session_s3_domain_name" {}
variable "optus_session_s3_bucket" {}
variable "optus_booking_s3_domain_name" {}
variable "optus_booking_s3_bucket" {}
# Vars from ACM module
variable "singtel_acm_cert_arn" {}
variable "he_acm_cert_arn" {}
variable "ais_acm_cert_arn" {}
variable "m1_acm_cert_arn" {}
variable "chat_engine_acm_cert_arn" {}
variable "starhub_acm_cert_arn" {}
variable "starhub_dhc_acm_cert_arn" {}
variable "starhub_screenrepair_acm_cert_arn" {}
variable "samsung_au_acm_cert_arn" {}
variable "horizon_engage_acm_cert_arn" {}
variable "celcom_acm_cert_arn" {}
variable "optus_session_acm_cert_arn" {}
variable "optus_booking_acm_cert_arn" {}
variable "env_version" {}

variable "depends_on_resource" {
    type = "string"
    default = ""
}