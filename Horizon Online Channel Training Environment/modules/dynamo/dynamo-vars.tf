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

data "aws_iam_role" "dynamodb_autoscaling_role" {
  name = "AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
}

variable "aws_region" {}
variable "iam_role" {}
variable "env_version" {}
variable "project_name" {}