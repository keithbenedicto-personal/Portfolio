output "singtel_acm_cert_arn" {
  value = "${aws_acm_certificate.singtel_acm_cert.arn}"
}
output "ais_acm_cert_arn" {
  value = "${aws_acm_certificate.ais_acm_cert.arn}"
}
output "m1_acm_cert_arn" {
  value = "${aws_acm_certificate.m1_acm_cert.arn}"
}
output "chat_engine_acm_cert_arn" {
  value = "${aws_acm_certificate.chat_engine_acm_cert.arn}"
} 
output "starhub_acm_cert_arn" {
  value = "${aws_acm_certificate.starhub_acm_cert.arn}"
}
output "starhub_screenrepair_acm_cert_arn" {
  value = "${aws_acm_certificate.starhub_screenrepair_acm_cert.arn}"
}
output "starhub_dhc_acm_cert_arn" {
  value = "${aws_acm_certificate.starhub_dhc_acm_cert.arn}"
}
output "samsung_au_acm_cert_arn" {
  value = "${aws_acm_certificate.samsung_au_acm_cert.arn}"
}  
output "celcom_acm_cert_arn" {
  value = "${aws_acm_certificate.celcom_acm_cert.arn}"
}
output "horizon_engage_acm_cert_arn" {
  value = "${aws_acm_certificate.horizon_engage_acm_cert.arn}"
}
output "optus_session_acm_cert_arn" {
  value = "${aws_acm_certificate.optus_session_acm_cert.arn}"
}
output "optus_booking_acm_cert_arn" {
  value = "${aws_acm_certificate.optus_booking_acm_cert.arn}"
}
output "he_acm_cert_arn" {
  value = "${aws_acm_certificate.he_acm_cert.arn}"
}
output "depends_on_resource" {
  value = "${null_resource.dummy_dependency.id}"
}

