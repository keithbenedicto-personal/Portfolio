output "sea-hrz-online-network-ec2-sg" {
    value = "${aws_security_group.sea-hrz-online-security-group-ec2.id}"
}

output "api-sg-id" {
  value = "${aws_security_group.api-sg.id}"
}

output "optus_api_sg" {
  value = "${aws_security_group.optus-api-sg.id}"
}