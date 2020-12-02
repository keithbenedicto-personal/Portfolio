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

resource "null_resource" "lambda_service_depends_on"{
  triggers = {
    deps = "${jsonencode(var.lambda_depends_on_resource)}"
  }
}


resource "aws_iam_role" "sea-hrz-online-lambda-dynamodb-access-iamrole" {
  name        = "${var.project_name}-lambda-dynamodb-access-iamrole-${var.tag_environment}"
  description = "Allows Lambda functions to call AWS resources on your behalf."
  assume_role_policy = "${var.iam_lambda_trust_relationship}"
  tags = {
    NAME              = "${var.project_name}-lambda-dynamodb-access-iamrole-${var.tag_environment}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
  }

}

resource "aws_iam_role" "sea-hrz-online-chatengine-auth-role" {
  depends_on  = ["null_resource.service_depends_on"]
  name        = "Cognito_${var.project_name}-chatengine-auth-role-${var.tag_environment}"
  description = "Cognito Chat Engine Authorized User Role"
  assume_role_policy = "${local.iam_chatengine_authuser_trust_relationship}"
  tags = {
    NAME              = "Cognito_${var.project_name}-chatengine-auth-role-${var.tag_environment}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
  }
}

resource "aws_iam_role" "sea-hrz-online-chatengine-unauth-role" {
  depends_on  = ["null_resource.service_depends_on"]
  name        = "Cognito_${var.project_name}-chatengine-unauth-role-${var.tag_environment}"
  description = "Cognito Chat Engine Unauthorized User Role"
  tags = {
    NAME              = "Cognito_${var.project_name}-chatengine-unauth-role-${var.tag_environment}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
  }
  assume_role_policy = "${local.iam_chatengine_unauthuser_trust_relationship}"
}

resource "aws_iam_policy" "sea-hrz-online-appsync-dynamodb-access-policy" {
  name        = "${var.project_name}-appsync-dynamodb-access-${var.tag_environment}"
  description = "Policy for Console One Online App Sync service to access DynamoDB"
  policy = "${local.iam_appsync_access_policy}"
}

resource "aws_iam_policy" "sea-hrz-online-appsync-common-policy" {
  name        = "${var.project_name}-appsync-common-policy-${var.tag_environment}"
  description = "CO HO AppSync Common Policy"
  policy = "${local.iam_sea_hrz_online_appsync_common_policy}" # !!
}

resource "aws_iam_policy" "sea-hrz-online-horizon-common-policy" {
  depends_on  = ["null_resource.service_depends_on"]
  name        = "${var.project_name}-horizon-common-policy-${var.tag_environment}"
  description = "CO HO Horizon Common Policy"
  policy = "${local.iam_sea_hrz_online_common_policy}" # !!
}

resource "aws_iam_role_policy_attachment" "attach-dynamodb-policy-to-access-iamrole" {
    role       = "${aws_iam_role.sea-hrz-online-lambda-dynamodb-access-iamrole.name}"
    policy_arn = "${aws_iam_policy.sea-hrz-online-appsync-dynamodb-access-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-appsync-policy-to-chatengine-auth-role" {
    role       = "${aws_iam_role.sea-hrz-online-chatengine-auth-role.name}"
    policy_arn = "${aws_iam_policy.sea-hrz-online-appsync-common-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-horizon-policy-to-chatengine-auth-role" {
    role       = "${aws_iam_role.sea-hrz-online-chatengine-auth-role.name}"
    policy_arn = "${aws_iam_policy.sea-hrz-online-horizon-common-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-appsync-policy-to-chatengine-unauth-role" {
    role       = "${aws_iam_role.sea-hrz-online-chatengine-unauth-role.name}"
    policy_arn = "${aws_iam_policy.sea-hrz-online-appsync-common-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-horizon-policy-to-chatengine-unauth-role" {
    role       = "${aws_iam_role.sea-hrz-online-chatengine-unauth-role.name}"
    policy_arn = "${aws_iam_policy.sea-hrz-online-horizon-common-policy.arn}"
}

# Test - for lambda
resource "aws_iam_role" "lambda-iamrole" {
  name = "${var.project_name}-lambda-iamrole-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com",
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    NAME              = "${var.project_name}-lambda-iamrole-${var.env}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
  }
}

resource "aws_iam_policy" "lambda-iam-policy" {
  name        = "${var.project_name}-${var.env}-lambda-policy"
  path        = "/service-role/"
  description = "Lambda IAM Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "LambdaActions",
      "Effect": "Allow",
      "Action": [
        "lambda:CreateFunction",
        "lambda:InvokeFunction",
        "lambda:GetFunction",
        "lambda:InvokeAsync",
        "lambda:GetFunctionConfiguration",
        "lambda:GetPolicy",
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudWatchActions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_policy_attachment" "lambda-policy-attachment" {
  name       = "${var.project_name}-${var.env}-lambda-policy-attachment"
  policy_arn = "${aws_iam_policy.lambda-iam-policy.arn}"
  roles      = ["${aws_iam_role.lambda-iamrole.id}"]
}

resource "time_sleep" "sleep-for-iam" {
  create_duration = "50s"
}


################
#Optus

resource "aws_iam_role" "anzhzn-optus-ecs-role" {
  name        = "anzhzn-optus-ecs-iamrole-${var.tag_environment}"
  description = "Compiled ecs policies for optus resources"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
  tags = {
    NAME              = "anzhzn-optus-ecs-iamrole-${var.tag_environment}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
  }
}

#OPTUS POLICIES

resource "aws_iam_policy" "optus-prnd-sns-policy" {
  name        = "anzhzn-optus-prnd-sns-${var.env}-policy"
  description = "Optus prnd SNS Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sns:CreatePlatformEndpoint",
                "sns:Publish"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "optus-s3-policy" {
  name        = "anzhzn-optus-s3-${var.env}-policy"
  description = "Optus s3 Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:AbortMultipartUpload",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::anzhzn-optus*",
                "arn:aws:s3:::anzhzn-optus*/*"
            ]
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "optus-prnd-dynamo-policy" {
  name        = "anzhzn-optus-prnd-dynamo-${var.env}-policy"
  description = "Optus prnd dynamo Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:ap-northeast-1:143854382227:table/anzhzn-optus*"
            ]
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "optus-prnd-appsync-policy" {
  name        = "anzhzn-optus-prnd-appsync-${var.env}-policy"
  description = "Optus prnd appsync Policy"
  policy = "${local.iam_optus_prnd_appsync_policy}" 
}

resource "aws_iam_policy" "optus-kms-policy" {
  name        = "anzhzn-optus-kms-${var.env}-policy"
  description = "Optus kms Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "optus-ssm-policy" {
  name        = "anzhzn-optus-ssm-${var.env}-policy"
  description = "Optus ssm Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2messages:GetEndpoint",
                "logs:DescribeLogStreams",
                "ec2messages:GetMessages",
                "ssm:PutConfigurePackageResult",
                "ssm:ListInstanceAssociations",
                "ssm:GetParameter",
                "ssm:UpdateAssociationStatus",
                "ssm:GetManifest",
                "logs:CreateLogStream",
                "ec2messages:DeleteMessage",
                "ssm:UpdateInstanceInformation",
                "ec2messages:FailMessage",
                "ssm:GetDocument",
                "lex:PostText",
                "ssm:PutComplianceItems",
                "ec2:DescribeInstanceStatus",
                "ssm:DescribeAssociation",
                "logs:DescribeLogGroups",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ec2messages:AcknowledgeMessage",
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "ssm:PutParameter",
                "ssm:PutInventory",
                "ec2messages:SendReply",
                "ssm:ListAssociations",
                "ssm:UpdateInstanceAssociationStatus"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucketMultipartUploads",
                "s3:AbortMultipartUpload",
                "s3:ListBucket",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::ssm-resource-sync-store/*",
                "arn:aws:s3:::ssm-resource-sync-store"
            ]
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "optus-cognito-policy" {
  depends_on  = ["null_resource.service_depends_on"]
  name        = "anzhzn-optus-cognito-${var.env}-policy"
  description = "Optus cognito Policy"
  policy = "${local.iam_optus_cognito_policy}" 
}

resource "aws_iam_policy" "optus-lambda-policy" {
  depends_on  = ["null_resource.lambda_service_depends_on"]
  name        = "anzhzn-optus-lambda-${var.env}-policy"
  description = "Optus lambda Policy"
  policy = "${local.iam_optus_lambda_policy}" 
}

#OPTUS ATTACHMENTS
resource "aws_iam_role_policy_attachment" "attach-optus-prnd-sns-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-prnd-sns-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-s3-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-s3-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-prnd-dynamo-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-prnd-dynamo-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-kms-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-kms-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-prnd-appsync-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-prnd-appsync-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-cognito-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-cognito-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-ssm-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-ssm-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-lambda-to-optus-ecs-role" {
    role       = "${aws_iam_role.anzhzn-optus-ecs-role.name}"
    policy_arn = "${aws_iam_policy.optus-lambda-policy.arn}"
}





#OPTUS ROLE 2 

resource "aws_iam_role" "anzhzn-optus-lambda-proxy-role" {
  name        = "anzhzn-optus-lambda-proxy-iamrole-${var.tag_environment}"
  description = "lambda proxy role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
  tags = {
    NAME              = "anzhzn-optus-lambda-proxy-iamrole-${var.tag_environment}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
  }
}


resource "aws_iam_policy" "optus-lambda-proxy-s3-policy" {
  name        = "anzhzn-lambda-proxy-s3-${var.env}-policy"
  description = "lambda proxy s3 policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:AbortMultipartUpload",
                "s3:ListBucket"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "optus-lambda-proxy-ec2-policy" {
  name        = "anzhzn-lambda-proxy-ec2-${var.env}-policy"
  description = "lambda proxy ec2 policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "optus-lambda-proxy-policy" {
  depends_on  = ["null_resource.lambda_service_depends_on"]
  name        = "anzhzn-lambda-proxy-${var.env}-policy"
  description = "lambda proxy Policy"
  policy = "${local.iam_optus_lambda_proxy_policy}" 
}

resource "aws_iam_role_policy_attachment" "attach-optus-lambda-proxy-to-optus-role" {
    role       = "${aws_iam_role.anzhzn-optus-lambda-proxy-role.name}"
    policy_arn = "${aws_iam_policy.optus-lambda-proxy-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-optus-lambda-proxy-s3-to-optus-role" {
    role       = "${aws_iam_role.anzhzn-optus-lambda-proxy-role.name}"
    policy_arn = "${aws_iam_policy.optus-lambda-proxy-s3-policy.arn}"
}
resource "aws_iam_role_policy_attachment" "attach-optus-lambda-proxy-ec2-to-optus-role" {
    role       = "${aws_iam_role.anzhzn-optus-lambda-proxy-role.name}"
    policy_arn = "${aws_iam_policy.optus-lambda-proxy-ec2-policy.arn}"
}
