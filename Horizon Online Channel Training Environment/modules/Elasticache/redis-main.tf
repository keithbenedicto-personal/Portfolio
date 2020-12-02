provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

resource "aws_elasticache_cluster" "redis_elasticache" {
  cluster_id           = "${var.project_name}-co-cache-${var.tag_environment}-${var.env_version}"
  engine               = "redis"
  node_type            = "cache.t2.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  tags                 = {
                            NAME = "${var.project_name}-co-cache-${var.tag_environment}-${var.env_version}"
                            BUSINESS_REGION = "${var.tag_business_region}"
                            BUSINESS_UNIT = "${var.tag_business_unit}"
                            PLATFORM = "${var.tag_platform}"
                            CLIENT = "${var.tag_client}"
                            ENVIRONMENT = "${var.tag_environment}"
                            ResourceCreatedBy = "${var.tag_resource_created_by}"
                         }
}

resource "aws_elasticache_cluster" "redis_elasticache_optus" {
  cluster_id           = "anzhzn-optus-cache-${var.tag_environment}-${var.env_version}"
  engine               = "redis"
  node_type            = "cache.t2.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  tags                 = {
                            NAME = "anzhzn-optus-cache-${var.tag_environment}-${var.env_version}"
                            BUSINESS_REGION = "${var.tag_business_region}"
                            BUSINESS_UNIT = "${var.tag_business_unit}"
                            PLATFORM = "${var.tag_platform}"
                            CLIENT = "${var.tag_client}"
                            ENVIRONMENT = "${var.tag_environment}"
                            ResourceCreatedBy = "${var.tag_resource_created_by}"
                         }
}