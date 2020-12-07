# provider "aws" {
#   alias = "module"
#   region = "${var.aws_region}"

#   assume_role {
#     role_arn = "${var.iam_role}"
#   }
# }

# resource "aws_ecs_cluster" "anzhzn_optus_ecs" {
#   name = "anzhzn-optus-ecs-${var.tag_environment}"
#   capacity_providers = ["FARGATE", "FARGATE_SPOT"]

#   setting {
#       name = "containerInsights"
#       value = "enabled"
#   }

#   tags {
#     BUSINESS_REGION   = "${var.tag_business_region}"
#     BUSINESS_UNIT     = "${var.tag_business_unit}"
#     CLIENT            = "${var.tag_client}"
#     ENVIRONMENT       = "${var.tag_environment}"
#     NAME              = "anzhzn-optus-ecs-${var.tag_environment}-${var.env_version}"
#     PLATFORM          = "${var.tag_platform}"
#     ResourceCreatedBy = "${var.tag_resource_created_by}"
#   }
# }

# resource "aws_ecs_task_definition" "anzhzn_optus_td" {
#   family                   = "anzhzn-optus-td-${var.tag_environment}"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 1024
#   memory                   = 2048
#   container_definitions    = file("ecs/optus-fargate.json")

#    tags {   
#     BUSINESS_REGION   = "${var.tag_business_region}"
#     BUSINESS_UNIT     = "${var.tag_business_unit}"
#     CLIENT            = "${var.tag_client}"
#     ENVIRONMENT       = "${var.tag_environment}"
#     NAME              = "anzhzn-optus-ecs-${var.tag_environment}-${var.env_version}"
#     PLATFORM          = "${var.tag_platform}"
#     ResourceCreatedBy = "${var.tag_resource_created_by}"
#   }
# }

# resource "aws_ecs_service" "anzhzn_optus_service" {
#   name            = "anzhzn-optus-service-${$var.tag_environment}"
#   cluster         = "${aws_ecs_cluster.anzhzn_optus_ecs.id}"
#   task_definition = "${aws_ecs_task_definition.anzhzn_optus_td.arn}"
#   desired_count   = 2
#   launch_type     = "FARGATE"

#   network_configuration {
#     security_groups  = "${var.optus_api_sg}"
#     subnets          = aws_subnet.private.*.id
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_alb_target_group.app.id
#     container_name   = "cb-app"
#     container_port   = var.app_port
#   }
# }