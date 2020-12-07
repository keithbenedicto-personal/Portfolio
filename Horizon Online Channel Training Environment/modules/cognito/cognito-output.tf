output "cognito_chatengine_identity_pool_id" {
    value = "${aws_cognito_identity_pool.cognito-chatengine-identity-pool.id}"
}

output "cognito_chatengine_identity_pool_arn" {
    value = "${aws_cognito_identity_pool.cognito-chatengine-identity-pool.arn}"
}
output "depends_on_resource" {
  value = "${null_resource.dummy_dependency.id}"
}