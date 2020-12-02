variable "tag_business_region" {
  type = "string"
}

variable "tag_business_unit" {
  type = "string"
}

variable "tag_platform" {
  type = "string"
}

variable "tag_client" {
  type = "string"
}

variable "tag_environment" {
  type = "string"
}

variable "tag_resource_created_by" {
  type = "string"
}

variable "aws_region" {}
variable "iam_role" {}
variable "env_version" {}
variable "project_name" {}

variable "optus_lb_output" {}
variable "optus_api_sg" {}