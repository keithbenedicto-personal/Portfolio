variable "aws_region" {
  type = "string"
}

variable "iam_role" {}

variable "aws_account_id" {
  type = "string"
}

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

variable "iam_lambda_trust_relationship" {
  type = "string"
}

variable "cognito_chatengine_user_pool_id" {
  type = "string"
}

variable "cognito_chatengine_user_pool_arn" {
  type = "string"
}

locals {
  iam_appsync_access_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Resource": "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/HO*"
    }
  ]
}
  EOF
  iam_chatengine_authuser_trust_relationship = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${var.cognito_chatengine_user_pool_id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
  EOF
  iam_chatengine_unauthuser_trust_relationship = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${var.cognito_chatengine_user_pool_id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
  EOF

#   iam_sea_hrz_online_horizon_common_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "cognito-identity:GetId",
#                 "cognito-identity:GetOpenIdToken",
#                 "cognito-identity:GetCredentialsForIdentity",
#                 "cognito-identity:UnlinkIdentity"
#             ],
#             "Resource": "${var.cognito_chatengine_user_pool_arn}"
#         },
#         {
#             "Sid": "VisualEditor1",
#             "Effect": "Allow",
#             "Action": "cognito-sync:*",
#             "Resource": "${var.cognito_chatengine_user_pool_arn}"
#         }
#     ]
# }
#   EOF

  iam_sea_hrz_online_appsync_common_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": "appsync:GraphQL",
        "Resource": "*"
    },
    {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
          "appsync:ListGraphqlApis",
          "appsync:GetGraphqlApi",
          "appsync:ListTypes",
          "appsync:GetResolver",
          "appsync:ListResolvers"
        ],
        "Resource": "*"
    }
  ]
}
  EOF

  iam_sea_hrz_online_common_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "cognito-identity:GetId",
        "cognito-identity:GetOpenIdToken",
        "cognito-identity:GetCredentialsForIdentity",
        "cognito-identity:UnlinkIdentity"
      ],
      "Resource": "${var.cognito_chatengine_user_pool_arn}"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": "cognito-sync:*",
      "Resource": "${var.cognito_chatengine_user_pool_arn}"
    }
  ]
}
  EOF

  iam_optus_prnd_appsync_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "appsync:GraphQL",
            "Resource": [
                "arn:aws:appsync:${var.aws_region}:${var.aws_account_id}:apis/${var.seahzn_appsync}",
                "arn:aws:appsync:${var.aws_region}:${var.aws_account_id}:apis/${var.seahzn_appsync}/types/*/fields/*"
            ]
        }
    ]
}
  EOF

  iam_optus_lambda_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": [
                "${var.optus_upload_lambda_invoke_arn}",
                "${var.optus_lambda_invoke_arn}"
            ]
        }
    ]
}
  EOF

  iam_optus_cognito_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cognito-idp:AdminInitiateAuth",
                "cognito-idp:AdminCreateUser"
            ],
            "Resource": "arn:aws:cognito-id:${var.aws_region}:${var.aws_account_id}:userpool/${var.cognito_chatengine_user_pool_id}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "cognito-idp:RespondToAuthChallenge",
            "Resource": "*"
        }
    ]
}
  EOF

  iam_optus_lambda_proxy_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${var.optus_lambda_invoke_arn}"
            ]
        }
    ]
}
  EOF
}

variable "env" {}
variable "project_name" {}
variable "seahzn_appsync" {}
variable "optus_lambda_invoke_arn" {}
variable "optus_upload_lambda_invoke_arn" {}
variable "depends_on_resource" {}             
variable "lambda_depends_on_resource" {} 