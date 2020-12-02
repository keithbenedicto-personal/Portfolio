provider "aws" {
  alias = "module"
  region = "${var.aws_region}"
}

#####################################################################################################
#seahzn-singtel-ol-training
resource "aws_acm_certificate" "singtel_acm_cert" {
  domain_name       = "${var.project_name}-singtel-ol-${var.tag_environment}.${var.asurion53_dns}"
  
  validation_method = "DNS"
  subject_alternative_names = [
    "${var.project_name}-singtel-${var.tag_environment}-online.${var.asurion53_dns}" #CNAME
  ]
  tags = {
    NAME              = "${var.project_name}-singtel-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "singtel_cert_validation_r53" {
  name    = "${aws_acm_certificate.singtel_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.singtel_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.singtel_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "singtel_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.singtel_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.singtel_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.singtel_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "singtel_cert_validation" {
  depends_on              = ["aws_route53_record.singtel_cert_validation_r53","aws_route53_record.singtel_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.singtel_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.singtel_cert_validation_r53.fqdn}","${aws_route53_record.singtel_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-chatengine-ol-training
resource "aws_acm_certificate" "chat_engine_acm_cert" {
  domain_name       = "${var.project_name}-chatengine-ol-${var.tag_environment}.${var.asurion53_dns}"
  validation_method = "DNS"
  tags = {
    NAME              = "${var.project_name}-chatengine-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "chat_engine_cert_validation_r53" {
  name    = "${aws_acm_certificate.chat_engine_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.chat_engine_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.chat_engine_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "chat_engine_cert_validation" {
  certificate_arn         = "${aws_acm_certificate.chat_engine_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.chat_engine_cert_validation_r53.fqdn}"]
}

#####################################################################################################
#seahzn-ais-ol-training
resource "aws_acm_certificate" "ais_acm_cert" {
  domain_name       = "${var.project_name}-ais-ol-${var.tag_environment}.${var.asurion53_dns}"
  validation_method = "DNS"
  subject_alternative_names = [
    "${var.project_name}-mobilecare-ais-${var.tag_environment}-online.${var.asurion53_dns}"
  ]
  tags = {
    NAME              = "${var.project_name}-ais-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "ais_cert_validation_r53" {
  name    = "${aws_acm_certificate.ais_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.ais_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.ais_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "ais_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.ais_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.ais_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.ais_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "ais_cert_validation" {
  depends_on              = ["aws_route53_record.ais_cert_validation_r53","aws_route53_record.ais_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.ais_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.ais_cert_validation_r53.fqdn}","${aws_route53_record.ais_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-starhub-ol-training
resource "aws_acm_certificate" "starhub_acm_cert" {
  domain_name       = "${var.project_name}-starhub-ol-${var.tag_environment}.${var.asurion53_dns}"
  subject_alternative_names = [
    "${var.project_name}-starhub-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  validation_method = "DNS"
  tags = {
    NAME              = "${var.project_name}-starhub-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "starhub_cert_validation_r53" {
  name    = "${aws_acm_certificate.starhub_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.starhub_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.starhub_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "starhub_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.starhub_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.starhub_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.starhub_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "starhub_cert_validation" {
  depends_on              = ["aws_route53_record.starhub_cert_validation_r53","aws_route53_record.starhub_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.starhub_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.starhub_cert_validation_r53.fqdn}","${aws_route53_record.starhub_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-starhubrepair-ol-training
resource "aws_acm_certificate" "starhub_screenrepair_acm_cert" {
  domain_name       = "${var.project_name}-starhubrepair-ol-${var.tag_environment}.${var.asurion53_dns}"
  subject_alternative_names = [
    "${var.project_name}-starhub-screenrepair-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  validation_method = "DNS"
  tags = {
    NAME              = "${var.project_name}-starhubrepair-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "starhub_screenrepair_cert_validation_r53" {
  name    = "${aws_acm_certificate.starhub_screenrepair_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.starhub_screenrepair_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.starhub_screenrepair_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "starhub_screenrepair_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.starhub_screenrepair_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.starhub_screenrepair_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.starhub_screenrepair_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "starhub_screenrepair_cert_validation" {
  depends_on              = ["aws_route53_record.starhub_screenrepair_cert_validation_r53","aws_route53_record.starhub_screenrepair_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.starhub_screenrepair_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.starhub_screenrepair_cert_validation_r53.fqdn}","${aws_route53_record.starhub_screenrepair_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-starhub-dhc-ol-training
resource "aws_acm_certificate" "starhub_dhc_acm_cert" {
  domain_name       = "${var.project_name}-starhub-dhc-ol-${var.tag_environment}.${var.asurion53_dns}"
  subject_alternative_names = [
    "${var.project_name}-starhub-dhc-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  validation_method = "DNS"
  tags = {
    NAME              = "${var.project_name}-starhub-dhc-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "starhub_dhc_cert_validation_r53" {
  name    = "${aws_acm_certificate.starhub_dhc_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.starhub_dhc_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.starhub_dhc_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "starhub_dhc_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.starhub_dhc_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.starhub_screenrepair_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.starhub_dhc_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "starhub_dhc_cert_validation" {
  depends_on              = ["aws_route53_record.starhub_dhc_cert_validation_r53","aws_route53_record.starhub_dhc_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.starhub_dhc_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.starhub_dhc_cert_validation_r53.fqdn}","${aws_route53_record.starhub_dhc_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-samsung-au-ol-training
resource "aws_acm_certificate" "samsung_au_acm_cert" {
  domain_name       = "${var.project_name}-samsung-au-ol-${var.tag_environment}.${var.asurion53_dns}"
  validation_method = "DNS"
  subject_alternative_names = [
    "${var.project_name}-samsung-au-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  tags = {
    NAME              = "${var.project_name}-samsung-au-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "samsung_au_cert_validation_r53" {
  name    = "${aws_acm_certificate.samsung_au_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.samsung_au_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.samsung_au_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "samsung_au_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.samsung_au_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.samsung_au_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.samsung_au_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "samsung_au_cert_validation" {
  depends_on              = ["aws_route53_record.samsung_au_cert_validation_r53","aws_route53_record.samsung_au_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.samsung_au_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.samsung_au_cert_validation_r53.fqdn}","${aws_route53_record.samsung_au_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-m1-ol-training
resource "aws_acm_certificate" "m1_acm_cert" {
  domain_name       = "${var.project_name}-m1-ol-${var.tag_environment}.${var.asurion53_dns}"
  validation_method = "DNS"
  subject_alternative_names = [
    "${var.project_name}-m1-fonecare-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  tags = {
    NAME              = "${var.project_name}-m1-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "m1_cert_validation_r53" {
  name    = "${aws_acm_certificate.m1_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.m1_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.m1_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "m1_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.m1_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.m1_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.m1_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "m1_cert_validation" {
  depends_on              = ["aws_route53_record.m1_cert_validation_r53","aws_route53_record.m1_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.m1_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.m1_cert_validation_r53.fqdn}","${aws_route53_record.m1_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-celcom-ol-training
resource "aws_acm_certificate" "celcom_acm_cert" {
  domain_name       = "${var.project_name}-celcom-ol-${var.tag_environment}.${var.asurion53_dns}"
  validation_method = "DNS"
  subject_alternative_names = [
    "${var.project_name}-celcom-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  tags = {
    NAME              = "${var.project_name}-celcom-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "celcom_cert_validation_r53" {
  name    = "${aws_acm_certificate.celcom_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.celcom_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.celcom_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "celcom_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.celcom_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.celcom_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.celcom_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "celcom_cert_validation" {
  depends_on              = ["aws_route53_record.celcom_cert_validation_r53","aws_route53_record.celcom_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.celcom_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.celcom_cert_validation_r53.fqdn}","${aws_route53_record.celcom_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#seahzn-hrz-engage-ol-training
resource "aws_acm_certificate" "horizon_engage_acm_cert" {
  domain_name       = "${var.project_name}-hrz-engage-ol-${var.tag_environment}.${var.asurion53_dns}"
  validation_method = "DNS"
  subject_alternative_names = [
    "${var.project_name}-horizon-engage-${var.tag_environment}.${var.asurion53_dns}"
  ]
  tags = {
    NAME              = "${var.project_name}-hrz-engage-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "horizon_engage_cert_validation_r53" {
  name    = "${aws_acm_certificate.horizon_engage_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.horizon_engage_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.horizon_engage_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "horizon_engage_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.horizon_engage_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.horizon_engage_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.horizon_engage_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "horizon_engage_cert_validation" {
  depends_on              = ["aws_route53_record.horizon_engage_cert_validation_r53","aws_route53_record.horizon_engage_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.horizon_engage_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.horizon_engage_cert_validation_r53.fqdn}","${aws_route53_record.horizon_engage_cert_validation_r53_alt.fqdn}"]
}


#####################################################################################################
#anzhzn-optus-ol-session
resource "aws_acm_certificate" "optus_session_acm_cert" {
  domain_name       = "anzhzn-optus-ol-session-${var.tag_environment}.${var.asurion53_dns}"
  validation_method = "DNS"
  subject_alternative_names = [
    "${var.project_name}-optus-session-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  tags = {
    NAME              = "anzhzn-optus-ol-session-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "optus_session_cert_validation_r53" {
  name    = "${aws_acm_certificate.optus_session_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.optus_session_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.optus_session_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "optus_session_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.optus_session_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.optus_session_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.optus_session_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "optus_session_cert_validation" {
  depends_on              = ["aws_route53_record.optus_session_cert_validation_r53","aws_route53_record.optus_session_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.optus_session_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.optus_session_cert_validation_r53.fqdn}","${aws_route53_record.optus_session_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#anzhzn-optus-ol-booking
resource "aws_acm_certificate" "optus_booking_acm_cert" {
  domain_name       = "anzhzn-optus-ol-booking-${var.tag_environment}.${var.asurion53_dns}"
  subject_alternative_names = [
    "${var.project_name}-optus-booking-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  validation_method = "DNS"
  tags = {
    NAME              = "anzhzn-optus-ol-booking-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "optus_booking_cert_validation_r53" {
  name    = "${aws_acm_certificate.optus_booking_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.optus_booking_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.optus_booking_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "optus_booking_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.optus_booking_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.optus_booking_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.optus_booking_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "optus_booking_cert_validation" {
  depends_on              = ["aws_route53_record.optus_booking_cert_validation_r53","aws_route53_record.optus_booking_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.optus_booking_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.optus_booking_cert_validation_r53.fqdn}","${aws_route53_record.optus_booking_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################
#anzhzn-he-ol-training
resource "aws_acm_certificate" "he_acm_cert" {
  domain_name       = "anzhzn-he-ol-${var.tag_environment}.${var.asurion53_dns}"
  subject_alternative_names = [
    "${var.project_name}-he-${var.tag_environment}.online.${var.asurion53_dns}"
  ]
  validation_method = "DNS"
  tags = {
    NAME              = "anzhzn-he-ol-${var.tag_environment}.${var.asurion53_dns}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    PLATFORM          = "${var.tag_platform}"
    EMAIL_DISTRIBUTION= "${var.tag_email_distribution}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "he_cert_validation_r53" {
  name    = "${aws_acm_certificate.he_acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.he_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.he_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "he_cert_validation_r53_alt" {
  name    = "${aws_acm_certificate.he_acm_cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.he_acm_cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.zone}"
  records = ["${aws_acm_certificate.he_acm_cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "he_cert_validation" {
  depends_on              = ["aws_route53_record.he_cert_validation_r53","aws_route53_record.he_cert_validation_r53_alt"]
  certificate_arn         = "${aws_acm_certificate.he_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.he_cert_validation_r53.fqdn}","${aws_route53_record.he_cert_validation_r53_alt.fqdn}"]
}

#####################################################################################################


resource "null_resource" "dummy_dependency" {
  depends_on = [
    "aws_acm_certificate_validation.singtel_cert_validation",
    "aws_acm_certificate_validation.chat_engine_cert_validation",
    "aws_acm_certificate_validation.ais_cert_validation",
    "aws_acm_certificate_validation.starhub_cert_validation", 
    "aws_acm_certificate_validation.starhub_screenrepair_cert_validation",
    "aws_acm_certificate_validation.starhub_dhc_cert_validation",
    "aws_acm_certificate_validation.samsung_au_cert_validation",
    "aws_acm_certificate_validation.m1_cert_validation",
    "aws_acm_certificate_validation.celcom_cert_validation",
    "aws_acm_certificate_validation.horizon_engage_cert_validation",
    "aws_acm_certificate_validation.optus_session_cert_validation",
    "aws_acm_certificate_validation.optus_booking_cert_validation",
    "aws_acm_certificate_validation.he_cert_validation"  
    ]
}