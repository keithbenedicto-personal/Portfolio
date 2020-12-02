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
asurion_net_dns          = "apac.prd.aws.asurion.net"
asurion53_dns            = "apac.asurion53.com"
aws_account_id           = "143854382227"
aws_profile              = "asurion-apac-prod.appadmins"
aws_subnet_1a_internal   = "subnet-447a4b0d"
aws_subnet_1c_internal   = "subnet-09eb8852"
aws_subnet_1d_internal   = "subnet-faf9ffd2"
aws_vpc                  = "vpc-8b7412ec"
env                      = "uat"
env_version              = "2"
iam_role                 = "arn:aws:iam::143854382227:role/Jenkins-Mobility-task"
tag_environment          = "uat"
tag_friendly_environment = "uat"
cognito_callback_urls    = "http://localhost:8080"
cognito_logout_urls      = "http://localhost:8080"
cognito_idenpool_prefix  = "sea hrz online"
zone                     = "apac.asurion53.com" #should be hosted zone ID

# Route53-specific Resources
resource_name = ["starhub-screenrepair","m1-fonecare"]