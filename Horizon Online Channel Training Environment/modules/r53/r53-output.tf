output "horizon-engage-r53" {
    value = "${aws_route53_record.sea-hrz-records-engage.id}"
}

output "he-optus-r53" {
    value = "${aws_route53_record.sea-hrz-records-he.id}"
}

output "depends_on_resource" {
  value = "${null_resource.dummy_dependency.id}"
}