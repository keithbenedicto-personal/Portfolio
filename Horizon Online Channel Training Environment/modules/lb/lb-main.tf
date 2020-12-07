# Test
provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

locals {
  lb_subnets = ["${var.aws_subnet_1a_internal}", "${var.aws_subnet_1c_internal}"]
}

# Creation of LB for ui-api
resource "aws_lb" "sea-hrz-ui-api-lb" {
  name               = "${var.project_name}-ui-api-lb-${var.tag_environment}-${var.env_version}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${var.sea-hrz-online-network-ec2-sg}"]
  # subnets            = ["${var.lb_subnets}"]
  subnets            = ["${local.lb_subnets}"]

  tags {
    NAME              = "${var.project_name}-ui-api-lb-${var.tag_environment}-${var.env_version}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# Creation of LB for svc
resource "aws_lb" "sea-hrz-svc-lb" {
  name               = "${var.project_name}-ui-svc-lb-${var.tag_environment}-${var.env_version}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${var.sea-hrz-online-network-ec2-sg}"]
  # subnets            = ["${var.lb_subnets}"]
  subnets            = ["${local.lb_subnets}"]

  tags {
    NAME              = "${var.project_name}-ui-svc-lb-${var.tag_environment}-${var.env_version}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# Creation of LB for ui
resource "aws_lb" "sea-hrz-ui-lb" {
  name               = "${var.project_name}-ui-lb-${var.tag_environment}-${var.env_version}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${var.sea-hrz-online-network-ec2-sg}"]
  # subnets            = ["${var.lb_subnets}"]
  subnets            = ["${local.lb_subnets}"]

  tags {
    NAME              = "${var.project_name}-ui-lb-${var.tag_environment}-${var.env_version}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
  
# Creation of LB for optus
resource "aws_lb" "anzhzn-optus-lb" {
  name               = "anzhzn-optus-lb-${var.tag_environment}-${var.env_version}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${var.sea-hrz-online-network-ec2-sg}"]
  # subnets            = ["${var.lb_subnets}"]
  subnets            = ["${local.lb_subnets}"]

  tags {
    NAME              = "anzhzn-optus-lb-${var.tag_environment}-${var.env_version}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}