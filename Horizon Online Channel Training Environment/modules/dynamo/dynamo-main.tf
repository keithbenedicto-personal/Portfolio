provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

resource "aws_dynamodb_table" "co_ho_dynamodb_visitor_table" {
  name           = "${var.project_name}-HOVisitor-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "visitorId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute = [{
    name = "visitorId"
    type = "S"
  }]

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "co-ho-dynamodb-${var.tag_environment}-HOVisitor"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#Optus DynamoDB
resource "aws_dynamodb_table" "horizon_online_device_preference" {
  name           = "anzhzn-optus-device-preference-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "profileId"
  range_key      = "featureId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "profileId"
    type = "S"
  }

  attribute {
    name = "featureId"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-device-preference-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_device_profile" {
  name           = "anzhzn-optus-device-profile-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "profileId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "profileId"
    type = "S"
  }

  attribute {
    name = "visitorId"
    type = "S"
  }

  global_secondary_index {
    name               = "visitorId-index"
    hash_key           = "visitorId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-device-profile-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_files_table" {
  name           = "anzhzn-optus-files-table-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "fileId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "fileId"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-files-table-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_video_audit" {
  name           = "anzhzn-optus-video-audit-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "videoAuditId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "videoAuditId"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = true
  } 

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-video-audit-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_video_request" {
  name           = "anzhzn-optus-video-request-dynamodb-${var.tag_environment}-${var.env_version}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "requestId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "requestId"
    type = "S"
  }
  
  attribute {
    name = "roomId"
    type = "S"
  }
  
  attribute {
    name = "expertId"
    type = "S"
  }
  
  attribute {
    name = "visitorId"
    type = "S"
  }

  global_secondary_index {
    name               = "roomId-index"
    hash_key           = "roomId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "expertId-index"
    hash_key           = "expertId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "visitorId-index"
    hash_key           = "visitorId"
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-video-request-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_voice_audit" {
  name           = "anzhzn-optus-voice-audit-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "voiceAuditId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "voiceAuditId"
    type = "S"
  }

  attribute {
    name = "requestId"
    type = "S"
  }

  global_secondary_index {
    name               = "requestId-index"
    hash_key           = "requestId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-voice-audit-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_voice_request" {
  name           = "anzhzn-optus-voice-request-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "requestId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "requestId"
    type = "S"
  }

  attribute {
    name = "sourceCallSid"
    type = "S"
  }

  attribute {
    name = "destinationCallSid"
    type = "S"
  }

  global_secondary_index {
    name               = "sourceCallSid-index"
    hash_key           = "sourceCallSid"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "destinationCallSid-index"
    hash_key           = "destinationCallSid"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-voice-request-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

#Horizon Online DynamoDBs

resource "aws_dynamodb_table" "horizon_online_canned_message_master" {
  name           = "${var.project_name}-canned-message-master-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "cannedMessageId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "cannedMessageId"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-canned-message-master-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_category_master" {
  name           = "${var.project_name}-category-master-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "categoryId"

  attribute {
    name = "categoryId"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-category-master-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_chat_request" {
  name           = "${var.project_name}-chat-request-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "requestId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "requestId"
    type = "S"
  }

  attribute {
    name = "mdn"
    type = "S"
  }

  attribute {
    name = "visitorId"
    type = "S"
  }

  global_secondary_index {
    name               = "mdn-index"
    hash_key           = "mdn"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "visitorId-index"
    hash_key           = "visitorId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-chat-request-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_chat_request_status" {
  name           = "${var.project_name}-chat-request-status-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "statusId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "statusId"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-chat-request-status-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_conversation" {
  name           = "${var.project_name}-conversation-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "conversationId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "conversationId"
    type = "S"
  }

  attribute {
    name = "requestId"
    type = "S"
  }

  global_secondary_index {
    name               = "requestId-index"
    hash_key           = "requestId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-conversation-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_general_inquiry" {
  name           = "${var.project_name}-general-inquiry-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "GENERAL_INQUIRY_ID"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "GENERAL_INQUIRY_ID"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-general-inquiry-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_message" {
  name           = "${var.project_name}-message-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "messageId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "messageId"
    type = "S"
  }

  attribute {
    name = "visitorId"
    type = "S"
  }

  global_secondary_index {
    name               = "visitorId-index"
    hash_key           = "visitorId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-message-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_visitor" {
  name           = "${var.project_name}-visitor-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "visitorId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "visitorId"
    type = "S"
  }

  attribute {
    name = "mdn"
    type = "S"
  }

  global_secondary_index {
    name               = "mdn-index"
    hash_key           = "mdn"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-visitor-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_chat_audit" {
  name           = "${var.project_name}-chat-audit-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "chatAuditId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "chatAuditId"
    type = "S"
  }

  attribute {
    name = "visitorId"
    type = "S"
  }

  global_secondary_index {
    name               = "visitorId-index"
    hash_key           = "visitorId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-chat-audit-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_dynamodb_table" "horizon_online_missed_utterances" {
  name           = "${var.project_name}-missed-utterances-dynamodb-${var.tag_environment}-${var.env_version}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "utteranceId"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "utteranceId"
    type = "S"
  }

  stream_enabled = false

  server_side_encryption {
    enabled = false
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-missed-utterances-dynamodb-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# HORIZON ONLINE - AUTO SCALING POLICIES
# 1. I did not add auto_scaling policies for all the tables, as this will be destroyed/created in a regular basis. I reviewed the contents of each table -
#    and just added auto_scaling policies on the tables that may need it based on their auto_scaling history.
# 2. auto_scaling policies have additonal costs. 

resource "aws_appautoscaling_target" "read_target_hovisitor" {
  max_capacity       = 40000
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.co_ho_dynamodb_visitor_table.name}"
  role_arn           = "${data.aws_iam_role.dynamodb_autoscaling_role.arn}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy_hovisitor" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target_hovisitor.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.read_target_hovisitor.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.read_target_hovisitor.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.read_target_hovisitor.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "write_target_hovisitor" {
  max_capacity       = 40000
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.co_ho_dynamodb_visitor_table.name}"
  role_arn           = "${data.aws_iam_role.dynamodb_autoscaling_role.arn}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy_hovisitor" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target_hovisitor.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.write_target_hovisitor.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.write_target_hovisitor.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.write_target_hovisitor.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "read_target_chat_request" {
  max_capacity       = 40000
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.horizon_online_chat_request.name}"
  role_arn           = "${data.aws_iam_role.dynamodb_autoscaling_role.arn}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy_chat_request" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target_chat_request.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.read_target_chat_request.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.read_target_chat_request.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.read_target_chat_request.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "write_target_chat_request" {
  max_capacity       = 40000
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.horizon_online_chat_request.name}"
  role_arn           = "${data.aws_iam_role.dynamodb_autoscaling_role.arn}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy_chat_request" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target_chat_request.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.write_target_chat_request.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.write_target_chat_request.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.write_target_chat_request.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70
  }
}
