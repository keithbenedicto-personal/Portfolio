provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

# === UI API ==============================================
resource "aws_api_gateway_rest_api" "ui-api-gateway" {
  name        = "${var.project_name}-ui-api-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["EDGE"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-ui-api-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_api_gateway_resource" "ui-api-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.ui-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.ui-api-gateway.root_resource_id}"
  path_part   = "{proxy+}" # Resource path: /{proxy+} !!
}

resource "aws_api_gateway_method" "ui-api-any-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.ui-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.ui-api-resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ui-api-any-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.ui-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.ui-api-resource.id}"
  http_method             = "${aws_api_gateway_method.ui-api-any-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "${var.ui_api_lambda_invoke_arn}"
}

resource "aws_api_gateway_method" "ui-api-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.ui-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.ui-api-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ui-api-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.ui-api-gateway.id}"
  resource_id = "${aws_api_gateway_resource.ui-api-resource.id}"
  http_method = "${aws_api_gateway_method.ui-api-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "ui-api-deployment" {
  depends_on        = [
    "aws_api_gateway_integration.ui-api-any-integration",
    "aws_api_gateway_integration.ui-api-options-integration"
  ]
  rest_api_id       = "${aws_api_gateway_rest_api.ui-api-gateway.id}"
  stage_name        = "${var.env}"
  description       = "Deployed using Terraform"
  stage_description = "Deployed using Terraform"
}

resource "aws_api_gateway_usage_plan" "ui-api-usage-plan" {
  name = "${var.project_name}-ui-api-${var.env}-usage-plan"
  
  api_stages {
    api_id = "${aws_api_gateway_rest_api.ui-api-gateway.id}"
    stage  = "${aws_api_gateway_deployment.ui-api-deployment.stage_name}"
  }

  throttle_settings {
    burst_limit = 5000
    rate_limit  = 10000
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-ui-api-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# === ChatEngine TokenAPI =================================
resource "aws_api_gateway_rest_api" "chat-engine-token-gateway" {
  name        = "${var.project_name}-chat-engine-token-api-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["EDGE"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-chat-engine-token-api-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_api_gateway_resource" "chat-engine-token-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.chat-engine-token-gateway.root_resource_id}"
  path_part   = "token" # Resource path: /token
}

resource "aws_api_gateway_resource" "chat-engine-methodname-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.chat-engine-token-resource.id}"
  path_part   = "{methodName}" # Resource path: /token/{methodName}
}

resource "aws_api_gateway_resource" "chat-engine-workersid-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.chat-engine-methodname-resource.id}"
  path_part   = "{workerSid}" # Resource path: /token/{methodName}/{workerSid}
}

resource "aws_api_gateway_method" "chat-engine-token-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.chat-engine-token-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "chat-engine-methodname-get-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.chat-engine-methodname-resource.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "chat-engine-methodname-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.chat-engine-methodname-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}


resource "aws_api_gateway_method" "chat-engine-workersid-get-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.chat-engine-workersid-resource.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "chat-engine-workersid-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.chat-engine-workersid-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "chat-engine-workersid-get-integration" {
  depends_on              = ["aws_api_gateway_method.chat-engine-workersid-get-method"]
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.chat-engine-workersid-resource.id}"
  http_method             = "${aws_api_gateway_method.chat-engine-workersid-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.chat_engine_token_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "chat-engine-workersid-options-integration" {
  depends_on              = ["aws_api_gateway_method.chat-engine-workersid-options-method"]
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id = "${aws_api_gateway_resource.chat-engine-workersid-resource.id}"
  http_method = "${aws_api_gateway_method.chat-engine-workersid-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "chat-engine-token-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id = "${aws_api_gateway_resource.chat-engine-token-resource.id}"
  http_method = "${aws_api_gateway_method.chat-engine-token-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "chat-engine-methodname-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.chat-engine-methodname-resource.id}"
  http_method             = "${aws_api_gateway_method.chat-engine-methodname-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.chat_engine_token_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "chat-engine-methodname-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-token-gateway.id}"
  resource_id = "${aws_api_gateway_resource.chat-engine-methodname-resource.id}"
  http_method = "${aws_api_gateway_method.chat-engine-methodname-options-method.http_method}"
  type        = "MOCK"
}

resource "time_sleep" "chat-engine-sleeper" {
  depends_on = ["aws_api_gateway_resource.chat-engine-workersid-resource"]
  create_duration = "30s"
}

# === chatengine backend ==================================
resource "aws_api_gateway_rest_api" "chat-engine-backend-gateway" {
  name        = "${var.project_name}-chat-engine-backend-endpoint-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-chat-engine-backend-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_api_gateway_resource" "backend-users-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.root_resource_id}"
  path_part   = "users" # Resource path: /users
}

resource "aws_api_gateway_resource" "backend-userid-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.backend-users-resource.id}"
  path_part   = "{userId}" # Resource path: /users/{userId}
}

resource "aws_api_gateway_resource" "backend-team-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.backend-userid-resource.id}"
  path_part   = "team" # Resource path: /users/{userId}/team
}

resource "aws_api_gateway_method" "backend-users-delete-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "backend-users-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "backend-users-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "backend-users-post-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "backend-users-put-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method      = "PUT"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "backend-userid-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.backend-userid-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "backend-userid-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.backend-userid-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "backend-team-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.backend-team-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "backend-team-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.backend-team-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "backend-users-delete-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method             = "${aws_api_gateway_method.backend-users-delete-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "DELETE"
  uri                     = "${var.chat_engine_backend_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "backend-users-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method             = "${aws_api_gateway_method.backend-users-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.chat_engine_backend_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "backend-users-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method = "${aws_api_gateway_method.backend-users-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "backend-users-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method             = "${aws_api_gateway_method.backend-users-post-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "${var.chat_engine_backend_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "backend-users-put-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.backend-users-resource.id}"
  http_method             = "${aws_api_gateway_method.backend-users-put-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "PUT"
  uri                     = "${var.chat_engine_backend_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "backend-userid-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.backend-userid-resource.id}"
  http_method             = "${aws_api_gateway_method.backend-userid-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.chat_engine_backend_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "backend-userid-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id = "${aws_api_gateway_resource.backend-userid-resource.id}"
  http_method = "${aws_api_gateway_method.backend-userid-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "backend-team-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.backend-team-resource.id}"
  http_method             = "${aws_api_gateway_method.backend-team-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.chat_engine_backend_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "backend-team-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  resource_id = "${aws_api_gateway_resource.backend-team-resource.id}"
  http_method = "${aws_api_gateway_method.backend-team-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "chat-engine-backend-deployment" {
  depends_on = [
    "aws_api_gateway_integration.backend-users-delete-integration",
    "aws_api_gateway_integration.backend-users-get-integration",
    "aws_api_gateway_integration.backend-users-options-integration",
    "aws_api_gateway_integration.backend-users-post-integration",
    "aws_api_gateway_integration.backend-users-put-integration",
    "aws_api_gateway_integration.backend-userid-get-integration",
    "aws_api_gateway_integration.backend-userid-options-integration",
    "aws_api_gateway_integration.backend-team-get-integration",
    "aws_api_gateway_integration.backend-team-options-integration"
  ]
  rest_api_id       = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
  stage_name        = "${var.env}"
  description       = "Deployed using Terraform"
  stage_description = "Deployed using Terraform"
}

resource "aws_api_gateway_usage_plan" "chat-engine-backend-usage-plan" {
  name = "${var.project_name}-chat-engine-backend-${var.env}-usage-plan"
  
  api_stages {
    api_id = "${aws_api_gateway_rest_api.chat-engine-backend-gateway.id}"
    stage  = "${aws_api_gateway_deployment.chat-engine-backend-deployment.stage_name}"
  }

  throttle_settings {
    burst_limit = 5000
    rate_limit  = 10000
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-chat-engine-backend-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# === api integrator endpoint =============================
resource "aws_api_gateway_rest_api" "api-integrator-gateway" {
  name        = "${var.project_name}-api-integrator-endpoint-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["EDGE"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-api-integrator-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_api_gateway_resource" "api-integrator-findagreements-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api-integrator-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.api-integrator-gateway.root_resource_id}"
  path_part   = "findagreements-soluto" # Resource path: /findagreements-soluto
}

resource "aws_api_gateway_method" "api-integrator-fa-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api-integrator-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.api-integrator-findagreements-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api-integrator-fa-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api-integrator-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.api-integrator-findagreements-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api-integrator-fa-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api-integrator-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.api-integrator-findagreements-resource.id}"
  http_method             = "${aws_api_gateway_method.api-integrator-fa-get-method.http_method}"
  type                    = "AWS"
  integration_http_method = "GET"
  uri                     = "${var.api_integrator_lambda_invoke_arn}" # !! sea-hrzol-api-integrator-sqa
}

resource "aws_api_gateway_integration" "api-integrator-fa-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api-integrator-gateway.id}"
  resource_id = "${aws_api_gateway_resource.api-integrator-findagreements-resource.id}"
  http_method = "${aws_api_gateway_method.api-integrator-fa-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "api-integrator-deployment" {
  depends_on = [
    "aws_api_gateway_integration.api-integrator-fa-get-integration",
    "aws_api_gateway_integration.api-integrator-fa-options-integration"
  ]
  rest_api_id       = "${aws_api_gateway_rest_api.api-integrator-gateway.id}"
  stage_name        = "${var.env}"
  description       = "Deployed using Terraform"
  stage_description = "Deployed using Terraform"
}

resource "aws_api_gateway_usage_plan" "api-integrator-usage-plan" {
  name = "${var.project_name}-api-integrator-endpoint-${var.env}-usage-plan"
  
  api_stages {
    api_id = "${aws_api_gateway_rest_api.api-integrator-gateway.id}"
    stage  = "${aws_api_gateway_deployment.api-integrator-deployment.stage_name}"
  }

  throttle_settings {
    burst_limit = 5000
    rate_limit  = 10000
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-api-integrator-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# === s3 file operations endpoint =========================
resource "aws_api_gateway_rest_api" "s3-file-ops-gateway" {
  name        = "${var.project_name}-s3-file-operations-endpoint-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["EDGE"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-s3-file-operations-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_api_gateway_resource" "s3-get-url-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.s3-file-ops-gateway.root_resource_id}"
  path_part   = "get-signed-url" # Resource path: /get-signed-url
}

resource "aws_api_gateway_resource" "s3-url-upload-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.s3-file-ops-gateway.root_resource_id}"
  path_part   = "get-signed-url-upload" # Resource path: /get-signed-url-upload
}

resource "aws_api_gateway_resource" "s3-upload-file-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.s3-file-ops-gateway.root_resource_id}"
  path_part   = "upload-file" # Resource path: /upload-file
}

resource "aws_api_gateway_method" "s3-get-url-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.s3-get-url-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "s3-get-url-post-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.s3-get-url-resource.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "s3-url-upload-options-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.s3-url-upload-resource.id}"
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    # true = required; false = optional
    "method.request.header.Access-Control-Allow-Headers" = false
    "method.request.header.Access-Control-Allow-Methods" = false
    "method.request.header.Access-Control-Allow-Origin"  = false
    "method.request.header.X-Requested-With"             = false
  }
}

resource "aws_api_gateway_method" "s3-url-upload-post-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.s3-url-upload-resource.id}"
  http_method      = "POST"
  authorization    = "NONE"
}

resource "aws_api_gateway_method" "s3-url-upload-put-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.s3-url-upload-resource.id}"
  http_method      = "PUT"
  authorization    = "NONE"

  request_parameters = {
    # true = required; false = optional
    "method.request.header.Accept"       = false
    "method.request.header.Content-Type" = false
  }
}

resource "aws_api_gateway_method" "s3-upload-file-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.s3-upload-file-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    # true = required; false = optional
    "method.request.header.Access-Control-Allow-Headers" = false
    "method.request.header.Access-Control-Allow-Methods" = false
    "method.request.header.Access-Control-Allow-Origin"  = false
    "method.request.header.X-Requested-With"             = false
  }
}

resource "aws_api_gateway_method" "s3-upload-file-post-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.s3-upload-file-resource.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    # true = required; false = optional
    "method.request.header.Accept"                       = false
    "method.request.header.Access-Control-Allow-Headers" = false
    "method.request.header.Access-Control-Allow-Methods" = false
    "method.request.header.Access-Control-Allow-Origin"  = false
    "method.request.header.Content-Type"                 = false
    "method.request.header.X-Requested-With"             = false
  }
  # Missing Request Body??
}

resource "aws_api_gateway_method" "s3-upload-file-put-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.s3-upload-file-resource.id}"
  http_method      = "PUT"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    # true = required; false = optional
    "method.request.header.Accept"       = false
    "method.request.header.Content-Type" = false
  }
}

resource "aws_api_gateway_integration" "s3-get-url-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id = "${aws_api_gateway_resource.s3-get-url-resource.id}"
  http_method = "${aws_api_gateway_method.s3-get-url-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "s3-get-url-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.s3-get-url-resource.id}"
  http_method             = "${aws_api_gateway_method.s3-get-url-post-method.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "${var.s3_file_operations_lambda_invoke_arn}" # !!
}

resource "aws_api_gateway_integration" "s3-url-upload-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id = "${aws_api_gateway_resource.s3-url-upload-resource.id}"
  http_method = "${aws_api_gateway_method.s3-url-upload-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "s3-url-upload-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.s3-url-upload-resource.id}"
  http_method             = "${aws_api_gateway_method.s3-url-upload-post-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "${var.s3_file_operations_lambda_invoke_arn}" # !!
}

resource "aws_api_gateway_integration" "s3-url-upload-put-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.s3-url-upload-resource.id}"
  http_method             = "${aws_api_gateway_method.s3-url-upload-put-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "PUT"
  uri                     = "${var.s3_file_operations_lambda_invoke_arn}" # !!
}

resource "aws_api_gateway_integration" "s3-upload-file-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id = "${aws_api_gateway_resource.s3-upload-file-resource.id}"
  http_method = "${aws_api_gateway_method.s3-upload-file-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "s3-upload-file-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.s3-upload-file-resource.id}"
  http_method             = "${aws_api_gateway_method.s3-upload-file-post-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "${var.s3_file_operations_lambda_invoke_arn}" # !!
}

resource "aws_api_gateway_integration" "s3-upload-file-put-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.s3-upload-file-resource.id}"
  http_method             = "${aws_api_gateway_method.s3-upload-file-put-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "PUT"
  uri                     = "${var.s3_file_operations_lambda_invoke_arn}" # !!
}

resource "aws_api_gateway_deployment" "s3-file-ops-deployment" {
  depends_on = [
    "aws_api_gateway_integration.s3-get-url-options-integration",
    "aws_api_gateway_integration.s3-get-url-post-integration",
    "aws_api_gateway_integration.s3-url-upload-options-integration",
    "aws_api_gateway_integration.s3-url-upload-post-integration",
    "aws_api_gateway_integration.s3-url-upload-put-integration",
    "aws_api_gateway_integration.s3-upload-file-options-integration",
    "aws_api_gateway_integration.s3-upload-file-post-integration",
    "aws_api_gateway_integration.s3-upload-file-put-integration"
  ]
  rest_api_id       = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
  stage_name        = "${var.env}"
  description       = "Deployed using Terraform"
  stage_description = "Deployed using Terraform"
}

resource "aws_api_gateway_usage_plan" "s3-file-ops-usage-plan" {
  name = "${var.project_name}-s3-file-operations-${var.env}-usage-plan"
  
  api_stages {
    api_id = "${aws_api_gateway_rest_api.s3-file-ops-gateway.id}"
    stage  = "${aws_api_gateway_deployment.s3-file-ops-deployment.stage_name}"
  }

  throttle_settings {
    burst_limit = 5000
    rate_limit  = 10000
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-s3-file-operations-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# === twilio integrator endpoint ==========================
resource "aws_api_gateway_rest_api" "twilio-endpoint-gateway" {
  name        = "${var.project_name}-twilio-integrator-endpoint-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["EDGE"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-twilio-integrator-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_api_gateway_resource" "twilio-fetch-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.root_resource_id}"
  path_part   = "fetch" # Resource path: /fetch
}

resource "aws_api_gateway_resource" "twilio-twilio-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.root_resource_id}"
  # !! Originally: /sea-horizon-online-twilio-integrator-ap-sqa-v2
  path_part   = "${var.project_name}-twilio-integrator-${var.env}"
}

resource "aws_api_gateway_resource" "twilio-token-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.root_resource_id}"
  path_part   = "token" # !! Resource path: /token
}

resource "aws_api_gateway_resource" "twilio-methodname-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.twilio-token-resource.id}"
  path_part   = "{methodName}" # !! Resource path: /token/{methodName}
}

resource "aws_api_gateway_resource" "twilio-workersid-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.twilio-methodname-resource.id}"
  path_part   = "{workerSid}" # !! Resource path: /token/{methodName}/{workerSid}
}

resource "aws_api_gateway_method" "twilio-fetch-get-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.twilio-fetch-resource.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    # true = required; false = optional
    "method.request.querystring.available"               = false
    "method.request.querystring.targetWorkersExpression" = true
    "method.request.querystring.taskQueueSid"            = true
  }
}

resource "aws_api_gateway_method" "twilio-fetch-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.twilio-fetch-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "twilio-twilio-any-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.twilio-twilio-resource.id}"
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "twilio-twilio-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.twilio-twilio-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "twilio-token-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.twilio-token-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "twilio-methodname-get-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.twilio-methodname-resource.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    # true = required; false = optional
    "method.request.path.methodName" = false
  }
}

resource "aws_api_gateway_method" "twilio-methodname-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.twilio-methodname-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    # true = required; false = optional
    "method.request.path.methodName" = false
  }
}

resource "aws_api_gateway_method" "twilio-workersid-get-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.twilio-workersid-resource.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    # true = required; false = optional
    "method.request.path.methodName" = false
    "method.request.path.workerSid"  = false
  }
}

resource "aws_api_gateway_method" "twilio-workersid-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.twilio-workersid-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    # true = required; false = optional
    "method.request.path.methodName" = false
    "method.request.path.workerSid"  = false
  }
}

resource "aws_api_gateway_integration" "twilio-fetch-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.twilio-fetch-resource.id}"
  http_method             = "${aws_api_gateway_method.twilio-fetch-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.twilio_integrator_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "twilio-fetch-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id = "${aws_api_gateway_resource.twilio-fetch-resource.id}"
  http_method = "${aws_api_gateway_method.twilio-fetch-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "twilio-twilio-any-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.twilio-twilio-resource.id}"
  http_method             = "${aws_api_gateway_method.twilio-twilio-any-method.http_method}"
  type                    = "AWS"
  integration_http_method = "ANY"
  uri                     = "${var.twilio_integrator_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "twilio-twilio-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id = "${aws_api_gateway_resource.twilio-twilio-resource.id}"
  http_method = "${aws_api_gateway_method.twilio-twilio-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "twilio-token-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id = "${aws_api_gateway_resource.twilio-token-resource.id}"
  http_method = "${aws_api_gateway_method.twilio-token-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "twilio-methodname-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.twilio-methodname-resource.id}"
  http_method             = "${aws_api_gateway_method.twilio-methodname-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.twilio_integrator_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "twilio-methodname-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id = "${aws_api_gateway_resource.twilio-methodname-resource.id}"
  http_method = "${aws_api_gateway_method.twilio-methodname-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "twilio-workersid-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.twilio-workersid-resource.id}"
  http_method             = "${aws_api_gateway_method.twilio-workersid-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.twilio_integrator_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "twilio-workersid-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  resource_id = "${aws_api_gateway_resource.twilio-workersid-resource.id}"
  http_method = "${aws_api_gateway_method.twilio-workersid-options-method.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "twilio-endpoint-deployment" {
  depends_on = [
    "aws_api_gateway_integration.twilio-fetch-get-integration",
    "aws_api_gateway_integration.twilio-fetch-options-integration",
    "aws_api_gateway_integration.twilio-twilio-any-integration",
    "aws_api_gateway_integration.twilio-twilio-options-integration",
    "aws_api_gateway_integration.twilio-token-options-integration",
    "aws_api_gateway_integration.twilio-methodname-get-integration",
    "aws_api_gateway_integration.twilio-methodname-options-integration",
    "aws_api_gateway_integration.twilio-workersid-get-integration",
    "aws_api_gateway_integration.twilio-workersid-options-integration"
  ]
  rest_api_id       = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
  stage_name        = "${var.env}"
  description       = "Deployed using Terraform"
  stage_description = "Deployed using Terraform"
}

resource "aws_api_gateway_usage_plan" "twilio-endpoint-usage-plan" {
  name = "${var.project_name}-twilio-endpiont-${var.env}-usage-plan"
  
  api_stages {
    api_id = "${aws_api_gateway_rest_api.twilio-endpoint-gateway.id}"
    stage  = "${aws_api_gateway_deployment.twilio-endpoint-deployment.stage_name}"
  }

  throttle_settings {
    burst_limit = 5000
    rate_limit  = 10000
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-twilio-integrator-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

# === starhub api integrator endpoint =====================
resource "aws_api_gateway_rest_api" "starhub-endpoint-gateway" {
  name        = "${var.project_name}-starhub-api-integrator-endpoint-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-starhub-api-integrator-endpoint-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_api_gateway_resource" "starhub-findagreements-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.starhub-endpoint-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.starhub-endpoint-gateway.root_resource_id}"
  path_part   = "findagreements-soluto" # Resource path: /findagreements-soluto
}

resource "aws_api_gateway_method" "starhub-findagreements-get-method" {
  rest_api_id      = "${aws_api_gateway_rest_api.starhub-endpoint-gateway.id}"
  resource_id      = "${aws_api_gateway_resource.starhub-findagreements-resource.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "api-integrator-findagreements-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.starhub-endpoint-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.starhub-findagreements-resource.id}"
  http_method             = "${aws_api_gateway_method.starhub-findagreements-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.starhub_integrator_lambda_invoke_arn}" # !! sea-starhub-online-sea-api-integrator
}

# No deployment configured for starhub endpoint API Gateway 

# === Optus api==================================
resource "aws_api_gateway_rest_api" "optus-api-gateway" {
  name        = "anzhzn-optus-api-${var.env}"
  description = "${var.description_default}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "anzhzn-optus-api-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
################## AUTH TOKEN ############################

resource "aws_api_gateway_resource" "optus-authtoken-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.optus-api-gateway.root_resource_id}"
  path_part   = "authtoken" # Resource path: /authtoken
}

resource "aws_api_gateway_method" "optus-authtoken-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-authtoken-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "optus-authtoken-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-authtoken-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "authtoken-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-authtoken-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-authtoken-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "authtoken-options-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-authtoken-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-authtoken-options-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "OPTIONS"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

################## COMPOSITION ############################

resource "aws_api_gateway_resource" "optus-composition-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.optus-api-gateway.root_resource_id}"
  path_part   = "composition" # Resource path: /composition
}

resource "aws_api_gateway_resource" "optus-composition-video-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-composition-resource.id}"
  path_part   = "video" # Resource path: /composition/video
}

resource "aws_api_gateway_resource" "optus-composition-callback-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-composition-video-resource.id}"
  path_part   = "callback" # Resource path: /composition/video/callback
}

resource "aws_api_gateway_resource" "optus-composition-requestid-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-composition-callback-resource.id}"
  path_part   = "{requestId}" # Resource path: /composition/video/callback/{requestId}
}

resource "aws_api_gateway_method" "optus-composition-post-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-composition-requestid-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "composition-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-composition-requestid-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-composition-post-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

################## EXPERT ############################

resource "aws_api_gateway_resource" "optus-expert-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.optus-api-gateway.root_resource_id}"
  path_part   = "expert" # Resource path: /expert
}

resource "aws_api_gateway_resource" "optus-expert-available-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-expert-resource.id}"
  path_part   = "available" # Resource path: /expert/available
}

resource "aws_api_gateway_resource" "optus-expert-sid-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-expert-available-resource.id}"
  path_part   = "{sid}" # Resource path: /expert/available/{sid}
}

resource "aws_api_gateway_resource" "optus-expert-secured-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-expert-sid-resource.id}"
  path_part   = "secured" # Resource path: /expert/available/{sid}/secured
}

resource "aws_api_gateway_method" "optus-expert-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-expert-secured-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "optus-expert-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-expert-secured-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "expert-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-expert-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-expert-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "expert-options-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-expert-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-expert-options-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "OPTIONS"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

################## PING ############################

resource "aws_api_gateway_resource" "optus-ping-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.optus-api-gateway.root_resource_id}"
  path_part   = "ping" # Resource path: /ping
}

resource "aws_api_gateway_method" "optus-ping-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-ping-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "optus-ping-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-ping-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ping-options-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-ping-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-ping-options-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "OPTIONS"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "ping-get-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-ping-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-ping-get-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.optus_lambda_invoke_arn}"
}


################## TASK ############################

resource "aws_api_gateway_resource" "optus-task-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.optus-api-gateway.root_resource_id}"
  path_part   = "task" # Resource path: /task
}

resource "aws_api_gateway_resource" "optus-task-cancel-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-task-resource.id}"
  path_part   = "cancel" # Resource path: /task/cancel
}

resource "aws_api_gateway_resource" "optus-task-cancel-taskid-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-task-cancel-resource.id}"
  path_part   = "{taskId}" # Resource path: /task/cancel/{taskId}
}

resource "aws_api_gateway_resource" "optus-task-cancel-secured-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-task-cancel-taskid-resource.id}"
  path_part   = "secured" # Resource path: /task/cancel/{taskId}/secured
}

resource "aws_api_gateway_method" "optus-task-put-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-task-cancel-secured-resource.id}"
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "optus-task-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-task-cancel-secured-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "task-put-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-task-cancel-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-task-put-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "PUT"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "task-options-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-task-cancel-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-task-options-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "OPTIONS"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_resource" "optus-task-channel-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-task-resource.id}"
  path_part   = "{channel}" # Resource path: /task/channel
}

resource "aws_api_gateway_resource" "optus-task-channel-secured-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-task-channel-resource.id}"
  path_part   = "secured" # Resource path: /task/channel/secured
}

resource "aws_api_gateway_method" "optus-task-channel-post-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-task-channel-secured-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "optus-task-channel-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-task-channel-secured-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "task-channel-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-task-channel-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-task-channel-post-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "task-channel-options-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-task-channel-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-task-channel-options-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "OPTIONS"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

################## VIDEO ############################

resource "aws_api_gateway_resource" "optus-video-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.optus-api-gateway.root_resource_id}"
  path_part   = "video" # Resource path: /video
}

resource "aws_api_gateway_resource" "optus-video-zero-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-video-resource.id}"
  path_part   = "{0}" # Resource path: /video/{0}
}

resource "aws_api_gateway_resource" "optus-video-type-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-video-zero-resource.id}"
  path_part   = "type" # Resource path: /video/{0}/type
}

resource "aws_api_gateway_resource" "optus-video-type-one-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-video-type-resource.id}"
  path_part   = "{1}" # Resource path: /video/{0}/type/{1}
}

resource "aws_api_gateway_resource" "optus-video-type-secured-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-video-type-one-resource.id}"
  path_part   = "secured" # Resource path: /video/{0}/type/{1}/secured
}

resource "aws_api_gateway_method" "optus-video-post-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-video-type-secured-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "optus-video-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-video-type-secured-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "video-options-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-video-type-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-video-options-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "OPTIONS"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "video-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-video-type-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-video-post-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_resource" "optus-video-one-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-video-zero-resource.id}"
  path_part   = "{1}" # Resource path: /video/{0}/{1}
}

resource "aws_api_gateway_resource" "optus-video-one-secured-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.optus-video-one-resource.id}"
  path_part   = "secured" # Resource path: /video/{0}/{1}/secured
}

resource "aws_api_gateway_method" "optus-video-one-post-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-video-one-secured-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "optus-video-one-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.optus-video-one-secured-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "video-one-post-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-video-one-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-video-one-post-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "${var.optus_lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "video-one-options-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  resource_id             = "${aws_api_gateway_resource.optus-video-one-secured-resource.id}"
  http_method             = "${aws_api_gateway_method.optus-video-one-options-method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "OPTIONS"
  uri                     = "${var.optus_lambda_invoke_arn}"
}
############################ OPTUS DEPLOYMENT ################################

resource "aws_api_gateway_deployment" "optus-deployment" {
  depends_on = [
    "aws_api_gateway_integration.video-one-post-integration",
    "aws_api_gateway_integration.video-one-options-integration",
    "aws_api_gateway_integration.video-post-integration",
    "aws_api_gateway_integration.video-options-integration",
    "aws_api_gateway_integration.task-channel-post-integration",
    "aws_api_gateway_integration.task-channel-options-integration",
    "aws_api_gateway_integration.task-options-integration",
    "aws_api_gateway_integration.task-put-integration",
    "aws_api_gateway_integration.ping-get-integration",
    "aws_api_gateway_integration.ping-options-integration",
    "aws_api_gateway_integration.expert-get-integration",
    "aws_api_gateway_integration.expert-options-integration",
    "aws_api_gateway_integration.composition-post-integration",
    "aws_api_gateway_integration.authtoken-get-integration",
    "aws_api_gateway_integration.authtoken-options-integration",    
  ]
  rest_api_id       = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
  stage_name        = "${var.env}"
  description       = "Deployed using Terraform"
  stage_description = "Deployed using Terraform"
}

resource "aws_api_gateway_usage_plan" "optus-usage-plan" {
  name = "anzhzn-optus-${var.env}-usage-plan"
  
  api_stages {
    api_id = "${aws_api_gateway_rest_api.optus-api-gateway.id}"
    stage  = "${aws_api_gateway_deployment.optus-deployment.stage_name}"
  }

  throttle_settings {
    burst_limit = 5000
    rate_limit  = 10000
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "anzhzn-optus-${var.env}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
