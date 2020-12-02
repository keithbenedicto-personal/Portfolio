provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

resource "null_resource" "service_depends_on"{
  triggers = {
    deps = "${jsonencode(var.depends_on_resource)}"
  }
}

resource "aws_cognito_identity_pool" "cognito-chatengine-identity-pool" {
  identity_pool_name               = "${var.cognito_idenpool_prefix} ${var.env} cognito chatengine identity pool"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client.cognito-asurion-user-pool-client-chatengine.id}"
    provider_name           = "cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.cognito-chatengine-user-pool.id}"
    server_side_token_check = false
  }

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client.cognito-asurion-user-pool-client-optus.id}"
    provider_name           = "cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.cognito-chatengine-user-pool.id}"
    server_side_token_check = false
  }

  saml_provider_arns           = ["${local.iam_saml_provider}"]
}

resource "aws_cognito_user_pool" "cognito-chatengine-user-pool" {
  name = "${var.project_name}-${var.env}-cognito-chatengine-user-pool"

  email_verification_subject = "Your verification code"
  email_verification_message = "Your verification code is {####}."

  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "email"
    required                 = true
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "custom:employeeID"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  password_policy {
    minimum_length    = 8
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
    require_lowercase = true
  }

  admin_create_user_config {
    unused_account_validity_days = 7

    invite_message_template {
      email_subject = "Your temporary password"
      email_message = "Your username is {username} and temporary password is {####}."
      sms_message   = "Your username is {username} and temporary password is {####}."
    }
  }

  tags {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-${var.env}-cognito-chatengine-user-pool"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_cognito_user_pool_client" "cognito-asurion-user-pool-client-chatengine" {
  depends_on          = ["null_resource.service_depends_on"]
  name = "${var.project_name}-${var.env}-chatengine"

  user_pool_id = "${aws_cognito_user_pool.cognito-chatengine-user-pool.id}"

  allowed_oauth_flows  = ["code", "implicit"]
  allowed_oauth_scopes = ["email", "openid", "profile"]

  callback_urls = ["https://seahzn-engage.apac.nonprod-asurion53.com/chat-console/"]
  logout_urls   = ["https://seahzn-engage.apac.nonprod-asurion53.com/"]
}

#https://route53 (horizon-engage) /chat-console/


resource "aws_cognito_user_pool_client" "cognito-asurion-user-pool-client-optus" {
  depends_on          = ["null_resource.service_depends_on"]
  name = "${var.project_name}-${var.env}-optus-he"

  user_pool_id = "${aws_cognito_user_pool.cognito-chatengine-user-pool.id}"

  allowed_oauth_flows  = ["code", "implicit"]
  allowed_oauth_scopes = ["email", "openid", "profile"]

  callback_urls = ["https://seahzn-he.apac.nonprod-asurion53.com/chat-console/"]
  logout_urls   = ["https://seahzn-he.apac.nonprod-asurion53.com/"]
}

#https://he (for optus) /chat-console/



resource "aws_cognito_user_pool_domain" "cognito-user-pool-domain" {
  domain       = "${var.project_name}-${var.env}-horizon-chat-engine"
  user_pool_id = "${aws_cognito_user_pool.cognito-chatengine-user-pool.id}"
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "aws_cognito_identity_pool.cognito-chatengine-identity-pool",
    ]
}