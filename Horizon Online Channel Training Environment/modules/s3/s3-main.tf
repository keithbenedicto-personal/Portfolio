resource "aws_s3_bucket" "sea-hrz-online-web-bucket" {
  bucket = "${var.project_name}-singtel-online-s3-${var.tag_environment}-${var.env_version}"
  //acl    = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-singtel-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-online-web-bucket-backup" {
  bucket = "${var.project_name}-singtel-online-s3-${var.tag_environment}-${var.env_version}-backup"
  //acl    = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-singtel-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-online-chat-engine-web" {
  bucket = "${var.project_name}-shared-online-chat-s3-${var.tag_environment}-${var.env_version}"
  //acl    = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-shared-online-chat-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-online-chat-engine-web-backup" {
  bucket = "${var.project_name}-shared-chat-engine-s3-${var.tag_environment}-${var.env_version}-backup"
  //acl    = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-shared-chat-engine-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-online-ais" {
  bucket = "${var.project_name}-ais-online-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-ais-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-online-ais-backup" {
  bucket = "${var.project_name}-ais-online-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-ais-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-starhub-smartsupport" {
  bucket = "${var.project_name}-starhub-online-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-starhub-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-starhub-smartsupport-backup" {
  bucket = "${var.project_name}-starhub-online-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-starhub-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-starhub-screenrepair" {
  bucket = "${var.project_name}-starhub-screenrepair-online-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-starhub-screenrepair-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-starhub-screenrepair-backup" {
  bucket = "${var.project_name}-starhub-screenrepair-online-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-starhub-screenrepair-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-dhc" {
  bucket = "${var.project_name}-starhub-dhc-online-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-starhub-dhc-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-dhc-backup" {
  bucket = "${var.project_name}-starhub-dhc-online-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-starhub-dhc-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-samsung" {
  bucket = "${var.project_name}-samsung-online-s3-${var.tag_environment}-${var.env_version}"
  ////////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-samsung-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-samsung-backup" {
  bucket = "${var.project_name}-samsung-online-s3-${var.tag_environment}-${var.env_version}-backup"
  ////////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-samsung-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-m1" {
  bucket = "${var.project_name}-m1-online-s3-${var.tag_environment}-${var.env_version}"
  ////////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-m1-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-m1-backup" {
  bucket = "${var.project_name}-m1-online-s3-${var.tag_environment}-${var.env_version}-backup"
  ////////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-m1-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-celcom" {
  bucket = "${var.project_name}-celcom-online-s3-${var.tag_environment}-${var.env_version}"
  ////////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-celcom-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-celcom-backup" {
  bucket = "${var.project_name}-celcom-online-s3-${var.tag_environment}-${var.env_version}-backup"
  ////////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-celcom-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
resource "aws_s3_bucket" "sea-hrz-engage" {
  bucket = "${var.project_name}-engage-online-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-engage-online-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-engage-backup" {
  bucket = "${var.project_name}-engage-online-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "${var.project_name}-engage-online-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-techcoach-session" {
  bucket = "anzhzn-optus-online-session-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-session-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-techcoach-session-backup" {
  bucket = "anzhzn-optus-online-session-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-session-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-techcoach-booking" {
  bucket = "anzhzn-optus-online-booking-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-booking-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-techcoach-booking-backup" {
  bucket = "anzhzn-optus-online-booking-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-booking-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
resource "aws_s3_bucket" "sea-hrz-he" {
  bucket = "anzhzn-optus-online-he-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-he-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-he-backup" {
  bucket = "anzhzn-optus-online-he-s3-${var.tag_environment}-${var.env_version}-backup"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-he-s3-${var.tag_environment}-${var.env_version}-backup"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-optus-expert" {
  bucket = "anzhzn-optus-online-expert-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-expert-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
resource "aws_s3_bucket" "sea-hrz-optus-recordings" {
  bucket = "anzhzn-optus-online-recordings-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-recordings-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
resource "aws_s3_bucket" "sea-hrz-optus-registration" {
  bucket = "anzhzn-optus-online-registration-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-registration-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}
resource "aws_s3_bucket" "sea-hrz-optus-email" {
  bucket = "anzhzn-optus-online-email-s3-${var.tag_environment}-${var.env_version}"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "anzhzn-optus-online-email-s3-${var.tag_environment}-${var.env_version}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

resource "aws_s3_bucket" "sea-hrz-training-ap" {
  bucket = "seahzn-${var.tag_environment}-${var.env_version}-ap"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "seahzn-${var.tag_environment}-${var.env_version}-ap"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

esource "aws_s3_bucket" "sea-hraz-config-apac-training" {
  bucket = "seahzn-config-apac-${var.tag_environment}-${var.env_version}-ap"
  //////acl = "private"

  tags = {
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    NAME              = "seahzn-config-apac-${var.tag_environment}-${var.env_version}-ap"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
  }
}

