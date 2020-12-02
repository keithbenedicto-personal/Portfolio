provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

data "aws_vpc" "vpc" {
  provider = "aws.module"
  tags = {
    Name = "*_APAC"
  }
}

data "aws_subnet_ids" "subnet-ids" {
  provider = "aws.module"
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags = {
    Name = "*_INTERNAL"
  }
}
#DONE
resource "aws_lambda_function" "ui-api-lambda" {
  function_name = "${var.project_name}-ui-api-${var.env}"
  description   = "${var.description_default}"
  runtime       = "nodejs10.x"
  role          = "${var.lambda_iamrole_arn}"

  s3_bucket     = "sea-hrz-config-ui-api-lambda" 
  s3_key        = "sea-horizon-online-ui-api.zip" 
  handler       = "index.handler" 
  memory_size   = 128 # Default is 128
  timeout       = 120 # Default is 3
  #kms_key_arn   = "arn:aws:kms:${var.aws_region}:${var.aws_account_id}:key/*" # !!

  vpc_config = {
    subnet_ids = ["subnet-acbfbf84","subnet-1671435f"]
    security_group_ids = ["${var.api_sg_id}"]
  }

  environment = {
    variables = {
      S3BUCKET = "consoleone-${var.env}-ap-config" # !!
      S3OBJECT = "config.web-${var.env}.json" # !!
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-ui-api-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
#DONE
resource "aws_lambda_function" "chat-engine-token-lambda" {
  function_name = "${var.project_name}-chat-engine-get-token-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs10.x"
  role          = "${var.lambda_iamrole_arn}" # !!

  s3_bucket     = "sea-hrz-config-chatengine-get-token" 
  s3_key        = "sea-horizon-online-chatengine-get-token.zip" 
  handler       = "twToken.handler" 

  environment = {
    variables = {
      S3BUCKET = "consoleone-${var.env}-ap-config" # !!
      S3OBJECT = "config.web-${var.env}.json" # !!
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-chat-engine-get-token-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
#DONE
resource "aws_lambda_function" "chat-engine-backend-lambda" {
  function_name = "${var.project_name}-chat-engine-backend-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs10.x"
  role          = "${var.lambda_iamrole_arn}" 

  s3_bucket     = "sea-hrz-config-chat-engine-backend" 
  s3_key        = "sea-horizon-online-chatengine-backend.zip" 
  handler       = "index.handler"
  environment = {
    variables = {
      S3BUCKET = "consoleone-${var.env}-ap-config" # !!
      S3OBJECT = "config.web-${var.env}.json" # !!
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-chat-engine-backend-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
#DONE
resource "aws_lambda_function" "api-integrator-lambda" {
  function_name = "${var.project_name}-api-integrator-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs10.x"
  role          = "${var.lambda_iamrole_arn}" 
  s3_bucket     = "sea-hrz-config-api-integrator"
  s3_key        = "sea-horizon-online-api-integrator.zip" 
  handler       = "index.handler"

  environment = {
    variables = {
      NODE_TLS_REJECT_UNAUTHORIZED = "0"
      S3BUCKET = "consoleone-${var.env}-ap-config" # !!
      S3OBJECT = "config.web-${var.env}.json" # !!
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-api-integrator-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
#DONE
resource "aws_lambda_function" "s3-file-operations-lambda" {
  function_name = "${var.project_name}-s3-file-operations-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs10.x"
  role          = "${var.lambda_iamrole_arn}" 
  s3_bucket     = "sea-hrz-config-s3-file-operations" 
  s3_key        = "sea-horizon-online-s3-file-operations.zip"
  handler       = "index.handler" 
  memory_size   = 128 # Default is 128
  timeout       = 30 # Default is 3

  environment = {
    variables = {
      S3BUCKET = "consoleone-${var.env}-ap-config" # !!
      S3OBJECT = "config.web-${var.env}.json" # !!
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-s3-file-operations-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
#DONE
resource "aws_lambda_function" "twilio-integrator-lambda" {
  function_name = "${var.project_name}-twilio-integrator-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs10.x"
  role          = "${var.lambda_iamrole_arn}" 

  s3_bucket     = "sea-hrz-config-twilio-integrator" 
  s3_key        = "sea-horizon-online-twilio-integrator.zip"
  handler       = "twToken.handler" 
  memory_size   = 128 # Default is 128
  timeout       = 30 # Default is 3

  environment = {
    variables = {
      S3BUCKET = "consoleone-${var.env}-ap-config" # !!
      S3OBJECT = "config.web-${var.env}.json" # !!
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-twilio-integrator-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
#DONE
resource "aws_lambda_function" "starhub-integrator-lambda" {
  function_name = "${var.project_name}-starhub-online-sea-api-integrator-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs10.x"
  role          = "${var.lambda_iamrole_arn}"

  s3_bucket     = "sea-hrz-config-starhub-api-integrator"
  s3_key        = "sea-horizon-online-starhub-api-integrator.zip" 
  handler       = "index.handler" 
  memory_size   = 128 # Default is 128
  timeout       = 120 # Default is 3
  kms_key_arn   = "" # !!

  vpc_config = {
    subnet_ids = ["subnet-3a8ae661","subnet-acbfbf84"]
    security_group_ids = ["${var.api_sg_id}"]
  }

  environment = {
    variables = {
      NODE_TLS_REJECT_UNAUTHORIZED = "0"
      S3BUCKET = "consoleone-${var.env}-ap-config" # !!
      S3OBJECT = "config.web-${var.env}.json" # !!
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "${var.project_name}-starhub-online-sea-api-integrator-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_lambda_function" "optus-lambda" {
  function_name = "anzhzn-optus-online-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs12.x"
  role          = "${var.lambda_iamrole_arn}"

  s3_bucket     = "anzhzn-config-optus" #anzhzn-upload-optus yung para sa isa
  s3_key        = "anzhzn-config-optus.zip" 
  handler       = "index.handler" 
  memory_size   = 128 # Default is 128
  timeout       = 120 # Default is 3
  kms_key_arn   = "" # !!

  vpc_config = {
    subnet_ids = ["subnet-3a8ae661","subnet-acbfbf84","subnet-1671435f"]
    security_group_ids = ["${var.api_sg_id}"]
  }

  environment = {
    variables = {
      TS_API_URL = "${var.optus_lb_output}" # 
    }
  }

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "anzhzn-optus-online-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_lambda_function" "optus-upload-lambda" {
  function_name = "anzhzn-optus-upload-${var.env}" # !!
  description   = "${var.description_default}"
  runtime       = "nodejs12.x"
  role          = "${var.lambda_iamrole_arn}"

  s3_bucket     = "anzhzn-upload-optus" 
  s3_key        = "anzhzn-upload-optus.zip" 
  handler       = "index.handler" 
  memory_size   = 128 # Default is 128
  timeout       = 120 # Default is 3
  kms_key_arn   = "" # !!


  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    Name              = "anzhzn-optus-online-${var.env}" # !!
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "aws_lambda_function.optus-lambda",
    "aws_lambda_function.optus-upload-lambda"
    ]
}

resource "time_sleep" "sleep-for-iam" {
  create_duration = "60s"
}
