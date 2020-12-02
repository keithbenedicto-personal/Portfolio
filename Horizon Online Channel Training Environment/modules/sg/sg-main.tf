provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

data "aws_vpc" "vpc" {
  provider = "aws.module"
  tags = {
    Name = "*_APAC"
  }
}

resource "aws_security_group" "sea-hrz-online-security-group-ec2" {
  name        = "${var.project_name}-shared-online-sg-ec2-${var.tag_environment}-${var.env_version}"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.40.0.0/16", "10.50.0.0/16", "172.28.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.40.0.0/16", "10.50.0.0/16"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["100.73.96.0/19"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "100.73.96.0/19", "172.28.0.0/16"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["100.73.96.0/19"]
  }
  ingress {
    from_port   = 32768
    to_port     = 40000
    protocol    = "tcp"
    cidr_blocks = ["100.73.96.0/19"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-shared-online-sg-ec2-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_security_group" "api-sg" {
  name        = "${var.project_name}-shared-online-sg-api-${var.tag_environment}-${var.env_version}"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["100.79.152.0/21","172.0.0.0/19","10.0.0.0/8","10.1.0.0/16","172.28.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-shared-online-sg-api-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_security_group" "optus-api-sg" {
  name        = "anzhzn-optus-api-sg-${var.tag_environment}-${var.env_version}"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["100.79.152.0/21", "10.0.0.0/8"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["100.79.144.0/21"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-api-sg-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}