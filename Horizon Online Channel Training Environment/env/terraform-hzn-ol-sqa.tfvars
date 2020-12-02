# Fixed Variables
asurion_dns             = "asurion.com"
aws_region              = "ap-northeast-1"
cognito_saml_file       = "saml.xml"
description_default     = "Created using Terraform"
platform                = "sea"
project_name            = "sea-hrz-online"
tag_business_region     = "APAC"
tag_business_unit       = "MOBILITY"
tag_client              = "MULTI_TENANT"
tag_email_distribution  = "IT-OPS-FO-APACJPNSquad@asurion.com"
tag_platform            = "HORIZON-APAC-SEA-ONLINE"
tag_resource_created_by = "Automation via Terraform"
tag_scheduler           = "INACTIVE"

# Account/environment-specific Variables
asurion_net_dns          = "apac.npr.aws.asurion.net"
asurion53_dns            = "apac.nonprod-asurion53.com"
aws_account_id           = "607516933194"
aws_profile              = "asurion-apac-nonprod.appadmins"
aws_subnet_1a_internal   = "subnet-1671435f"
aws_subnet_1c_internal   = "subnet-3a8ae661"
aws_subnet_1d_internal   = "subnet-acbfbf84"
aws_vpc                  = "vpc-03402264"
env                      = "sqa"
env_version              = "2"
iam_role                 = "arn:aws:iam::607516933194:role/consoleone-iac-npr"
tag_environment          = "sqa"
tag_friendly_environment = "sqa"
cognito_callback_urls    = "http://localhost:8080"
cognito_logout_urls      = "http://localhost:8080"
cognito_idenpool_prefix  = "sea hrz online"
zone                     = "Z1HTM5IXLIW6ZI"

# Route53-specific Resources
resource_name = ["mobilecare-ais","m1-fonecare"]