provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}

resource "aws_route53_record" "sea-hrz-records-singtel" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-singtel-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.singtel_online_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-chatengine" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-chatengine-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.singtel_chat_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-ais" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-ais-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.ais_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-starhub" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-starhub-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.starhub_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-starhub-screenrepair" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-starhubrepair-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.starhub_screenrepair_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-starhub-dhc" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-starhub-dhc-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.starhub_dhc_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-samsung" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-samsung-au-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.samsung_au_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-m1" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-m1-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.m1_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-celcom" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-celcom-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.celcom_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-engage" {
	zone_id = "${var.zone}"
	name = "${var.project_name}-hrz-engage-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.horizon_engage_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-optus-session" {
	zone_id = "${var.zone}"
	name = "anzhzn-optus-ol-session-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.optus_session_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-optus-booking" {
	zone_id = "${var.zone}"
	name = "anzhzn-optus-ol-booking-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.optus_booking_cf_id}"]
}

resource "aws_route53_record" "sea-hrz-records-he" {
	zone_id = "${var.zone}"
	name = "anzhzn-he-ol-${var.tag_environment}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.he_cf_id}"]
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "aws_route53_record.sea-hrz-records-engage",
    "aws_route53_record.sea-hrz-records-he",
    ]
}