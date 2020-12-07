provider "aws" {
  assume_role {
    role_arn = "${var.iam_role}"
  }
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "aws" {
  alias   = "acm"
  assume_role {
    role_arn = "${var.iam_role}"
  }
  region  = "us-east-1"
  profile = "${var.aws_profile}"
}

terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "bucket_name"
    region  = "ap-northeast-1"
    profile = ""
    key     = ".tfstate"
  }
}

module "acm" {
  source = "../modules/acm"
  providers  {
    aws = "aws.acm"
  }
  env                     = "${var.env}"
  asurion53_dns           = "${var.asurion53_dns}"
  asurion_net_dns         = "${var.asurion_net_dns}"
  aws_region              = "us-east-1"
  project_name            = "${var.project_name}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  tag_email_distribution  = "${var.tag_email_distribution}"
  zone                    = "${var.zone}"  
  tag_environment         = "${var.tag_environment}"
}

module "appsync" {
  source = "../modules/appsync"
  aws_region              = "${var.aws_region}"
  iam_role                = "${var.iam_role}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  tag_email_distribution  = "${var.tag_email_distribution}"
  tag_environment         = "${var.tag_environment}"
  project_name            = "${var.project_name}"
  env_version             = "${var.env_version}"
}

module "api" {
  source                  = "../modules/api"
  aws_region              = "${var.aws_region}"
  iam_role                = "${var.iam_role}"
  description_default     = "${var.description_default}"
  env                     = "${var.env}"
  project_name            = "${var.project_name}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
# Vars from Lambda Module
  ui_api_lambda_invoke_arn              = "${module.lambda.ui-api-lambda-invoke-arn}"
  chat_engine_token_lambda_invoke_arn   = "${module.lambda.chat-engine-token-lambda-invoke-arn}"
  chat_engine_backend_lambda_invoke_arn = "${module.lambda.chat-engine-backend-lambda-invoke-arn}"
  api_integrator_lambda_invoke_arn      = "${module.lambda.api-integrator-lambda-invoke-arn}"
  s3_file_operations_lambda_invoke_arn  = "${module.lambda.s3-file-operations-lambda-invoke-arn}"
  twilio_integrator_lambda_invoke_arn   = "${module.lambda.twilio-integrator-lambda-invoke-arn}"
  starhub_integrator_lambda_invoke_arn  = "${module.lambda.starhub-integrator-lambda-invoke-arn}"
  optus_lambda_invoke_arn               = "${module.lambda.optus-lambda-invoke-arn}"
}

module "cognito" {
    source                    = "../modules/cognito"
    env                       = "${var.env}"
    project_name              = "${var.project_name}"
    aws_account_id            = "${var.aws_account_id}"
    aws_region                = "${var.aws_region}"
    iam_role                  = "${var.iam_role}"
    cognito_saml_file         = "${var.cognito_saml_file}"
    tag_business_region       = "${var.tag_business_region}"
    tag_business_unit         = "${var.tag_business_unit}"
    tag_client                = "${var.tag_client}"
    tag_environment           = "${var.tag_environment}"
    tag_platform              = "${var.tag_platform}"
    tag_resource_created_by   = "${var.tag_resource_created_by}"
    cognito_idenpool_prefix   = "${var.cognito_idenpool_prefix}"
    cognito_callback_urls     = "${var.cognito_callback_urls}"
    cognito_logout_urls       = "${var.cognito_logout_urls}"
  # Vars from r53 Module
    horizon_engage_r53        = "${module.r53.horizon-engage-r53}"
    he_optus_r53              = "${module.r53.he-optus-r53}"
    depends_on_resource       = "${module.r53.depends_on_resource}"
}

module "cf" {
  source                  = "../modules/cf"
  aws_region              = "${var.aws_region}"
  asurion_dns             = "${var.asurion_dns}"
  env                     = "${var.env}"
  iam_role                = "${var.iam_role}"
  project_name            = "${var.project_name}"
  asurion53_dns           = "${var.asurion53_dns}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  asurion_net_dns         = "${var.asurion_net_dns}"
  env_version             = "${var.env_version}"
  tag_environment         = "${var.tag_environment}"
  # Vars from API module
  ui_api_invoke_url          = "${module.api.ui_api_invoke_url}"
  twilio_endpoint_invoke_url = "${module.api.twilio_endpoint_invoke_url}"
  
  # Vars from S3 module
  singtel_s3_bucket                   = "${module.s3.singtel_s3_bucket}"            
  singtel_s3_domain_name              = "${module.s3.singtel_s3_domain_name}"
  chat_engine_s3_bucket               = "${module.s3.chatengine_s3_bucket}"
  chat_engine_s3_domain_name          = "${module.s3.chatengine_s3_domain_name}"
  ais_s3_bucket                       = "${module.s3.ais_s3_bucket}"
  ais_s3_domain_name                  = "${module.s3.ais_s3_domain_name}"
  starhub_s3_bucket                   = "${module.s3.starhub_s3_bucket}"
  starhub_s3_domain_name              = "${module.s3.starhub_s3_domain_name}"
  starhub_screenrepair_s3_bucket      = "${module.s3.starhub_screenrepair_s3_bucket}"
  starhub_screenrepair_s3_domain_name = "${module.s3.starhub_screenrepair_s3_domain_name}"
  starhub_dhc_s3_bucket               = "${module.s3.starhub_dhc_s3_bucket}"
  starhub_dhc_s3_domain_name          = "${module.s3.starhub_dhc_s3_domain_name}"
  samsung_s3_domain_name              = "${module.s3.samsung_s3_domain_name}"
  samsung_s3_bucket                   = "${module.s3.samsung_s3_bucket}"
  m1_s3_bucket                        = "${module.s3.m1_s3_bucket}"
  m1_s3_domain_name                   = "${module.s3.m1_s3_domain_name}"
  celcom_s3_bucket                    = "${module.s3.celcom_s3_bucket}"
  celcom_s3_domain_name               = "${module.s3.celcom_s3_domain_name}"
  engage_s3_bucket                    = "${module.s3.engage_s3_bucket}"
  engage_s3_domain_name               = "${module.s3.engage_s3_domain_name}"
  optus_session_s3_bucket             = "${module.s3.optus_session_s3_bucket}"
  optus_session_s3_domain_name        = "${module.s3.optus_session_s3_domain_name}"
  optus_booking_s3_bucket             = "${module.s3.optus_booking_s3_bucket}"
  optus_booking_s3_domain_name        = "${module.s3.optus_booking_s3_domain_name}"
  he_s3_bucket                        = "${module.s3.he_s3_bucket}"
  he_s3_domain_name                   = "${module.s3.he_s3_domain_name}"
  # Vars from ACM module
  singtel_acm_cert_arn              = "${module.acm.singtel_acm_cert_arn}" #singtel_online
  chat_engine_acm_cert_arn          = "${module.acm.chat_engine_acm_cert_arn}" #singtel_chat
  ais_acm_cert_arn                  = "${module.acm.ais_acm_cert_arn}"
  starhub_acm_cert_arn              = "${module.acm.starhub_acm_cert_arn}"
  starhub_screenrepair_acm_cert_arn = "${module.acm.starhub_screenrepair_acm_cert_arn}"
  starhub_dhc_acm_cert_arn          = "${module.acm.starhub_dhc_acm_cert_arn}"
  m1_acm_cert_arn                   = "${module.acm.m1_acm_cert_arn}"
  samsung_au_acm_cert_arn           = "${module.acm.samsung_au_acm_cert_arn}"
  celcom_acm_cert_arn               = "${module.acm.celcom_acm_cert_arn}"
  horizon_engage_acm_cert_arn       = "${module.acm.horizon_engage_acm_cert_arn}"
  optus_session_acm_cert_arn        = "${module.acm.optus_session_acm_cert_arn}"
  optus_booking_acm_cert_arn        = "${module.acm.optus_booking_acm_cert_arn}"
  he_acm_cert_arn                   = "${module.acm.he_acm_cert_arn}"
  depends_on_resource               = "${module.acm.depends_on_resource}"
}

module "dynamo" {
  source                  = "../modules/dynamo"
  aws_region              = "${var.aws_region}"
  iam_role                = "${var.iam_role}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_environment         = "${var.tag_environment}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  env_version             = "${var.env_version}"
  project_name            = "${var.project_name}"
}

module "iam" {
  source                           = "../modules/iam"
  aws_account_id                   = "${var.aws_account_id}"
  aws_region                       = "${var.aws_region}"
  iam_role                         = "${var.iam_role}"
  #output
  cognito_chatengine_user_pool_arn = "${module.cognito.cognito_chatengine_identity_pool_arn}"
  cognito_chatengine_user_pool_id  = "${module.cognito.cognito_chatengine_identity_pool_id}"
  seahzn_appsync                   = "${module.appsync.seahzn_appsync}"
  optus_lambda_invoke_arn          = "${module.lambda.optus-lambda-invoke-arn}"
  optus_upload_lambda_invoke_arn   = "${module.lambda.optus-upload-lambda-invoke-arn}"
  #tags
  env                              = "${var.env}"
  iam_lambda_trust_relationship    = "${var.iam_lambda_trust_relationship}"
  project_name                     = "${var.project_name}"
  tag_business_region              = "${var.tag_business_region}"
  tag_business_unit                = "${var.tag_business_unit}"
  tag_client                       = "${var.tag_client}"
  tag_environment                  = "${var.tag_environment}"
  tag_platform                     = "${var.tag_platform}"
  tag_resource_created_by          = "${var.tag_resource_created_by}"
  depends_on_resource              = "${module.cognito.depends_on_resource}"
  lambda_depends_on_resource       = "${module.lambda.lambda_depends_on_resource}"
}

module "lambda" {
  source                  = "../modules/lambda"
  api_sg_id               = "${module.sg.api-sg-id}"
  aws_account_id          = "${var.aws_account_id}"
  aws_region              = "${var.aws_region}"
  description_default     = "${var.description_default}"
  env                     = "${var.env}"
  iam_role                = "${var.iam_role}"
  lambda_iamrole_arn      = "${module.iam.sea-hrz-online-lambda-iamrole-arn}"
  project_name            = "${var.project_name}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  optus_lb_output         = "${module.lb.optus_lb_output}"
}


module "lb" {
   source                        = "../modules/lb"
   aws_region                    = "${var.aws_region}"
   iam_role                      = "${var.iam_role}"
   aws_subnet_1a_internal        = "${var.aws_subnet_1a_internal}"
   aws_subnet_1c_internal        = "${var.aws_subnet_1c_internal}"
   project_name                  = "${var.project_name}"
   env_version                   = "${var.env_version}"
   sea-hrz-online-network-ec2-sg = "${module.sg.sea-hrz-online-network-ec2-sg}"
   tag_business_region           = "${var.tag_business_region}"
   tag_business_unit             = "${var.tag_business_unit}"
   tag_client                    = "${var.tag_client}"
   tag_environment               = "${var.tag_environment}"
   tag_platform                  = "${var.tag_platform}"
   tag_resource_created_by       = "${var.tag_resource_created_by}"
 }

 module "r53" {
   source                             = "../modules/r53"
   aws_region                         = "${var.aws_region}"
   iam_role                           = "${var.iam_role}"
   zone                               = "${var.zone}"
   tag_business_region                = "${var.tag_business_region}"
   tag_business_unit                  = "${var.tag_business_unit}"
   tag_client                         = "${var.tag_client}"
   tag_environment                    = "${var.tag_environment}"
   tag_platform                       = "${var.tag_platform}"
   tag_resource_created_by            = "${var.tag_resource_created_by}"
   env_version                        = "${var.env_version}"
   project_name                       = "${var.project_name}"
   #OUTPUT OF CF
   starhub_screenrepair_cf_id         = "${module.cf.starhub_screenrepair_cf_id}"
   m1_cf_id                           = "${module.cf.m1_cf_id}"
   ais_cf_id                          = "${module.cf.ais_cf_id}"
   singtel_chat_cf_id                 = "${module.cf.singtel_chat_cf_id}"
   singtel_online_cf_id               = "${module.cf.singtel_online_cf_id}"
   starhub_cf_id                      = "${module.cf.starhub_cf_id}"
   starhub_dhc_cf_id                  = "${module.cf.starhub_dhc_cf_id}"
   samsung_au_cf_id                   = "${module.cf.samsung_au_cf_id}"
   horizon_engage_cf_id               = "${module.cf.horizon_engage_cf_id}"
   celcom_cf_id                       = "${module.cf.celcom_cf_id}"
   optus_session_cf_id                = "${module.cf.optus_session_cf_id}"
   optus_booking_cf_id                = "${module.cf.optus_booking_cf_id}"
   he_cf_id                           = "${module.cf.he_cf_id}"
}

module "s3" {
  source                  = "../modules/s3"
  project_name            = "${var.project_name}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_environment         = "${var.tag_environment}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  env_version             = "${var.env_version}"
}

module "sg" {
  source                  = "../modules/sg"
  aws_region              = "${var.aws_region}"
  iam_role                = "${var.iam_role}"
  env                     = "${var.env}"
  project_name            = "${var.project_name}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_environment         = "${var.tag_environment}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  env_version             = "${var.env_version}"
}

module "elasticache" {
  source                  = "../modules/Elasticache"
  iam_role                = "${var.iam_role}"
  env_version             = "${var.env_version}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_environment         = "${var.tag_environment}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  aws_region              = "${var.aws_region}"
  project_name            = "${var.project_name}"
}

module "ecs" {
  source                  = "../modules/ecs"
  optus_lb_output         = "${module.lb.optus_lb_output}"
  optus_api_sg            = "${module.sg.optus_api_sg}"
  iam_role                = "${var.iam_role}"
  env_version             = "${var.env_version}"
  tag_business_region     = "${var.tag_business_region}"
  tag_business_unit       = "${var.tag_business_unit}"
  tag_client              = "${var.tag_client}"
  tag_environment         = "${var.tag_environment}"
  tag_platform            = "${var.tag_platform}"
  tag_resource_created_by = "${var.tag_resource_created_by}"
  aws_region              = "${var.aws_region}"
  project_name            = "${var.project_name}"
}
