output "ui-api-lambda-invoke-arn" {
  value = "${aws_lambda_function.ui-api-lambda.invoke_arn}"
}

output "chat-engine-token-lambda-invoke-arn" {
  value = "${aws_lambda_function.chat-engine-token-lambda.invoke_arn}"
}

output "chat-engine-backend-lambda-invoke-arn" {
  value = "${aws_lambda_function.chat-engine-backend-lambda.invoke_arn}"
}

output "api-integrator-lambda-invoke-arn" {
  value = "${aws_lambda_function.api-integrator-lambda.invoke_arn}"
}

output "starhub-integrator-lambda-invoke-arn" {
  value = "${aws_lambda_function.starhub-integrator-lambda.invoke_arn}"
}

output "twilio-integrator-lambda-invoke-arn" {
  value = "${aws_lambda_function.twilio-integrator-lambda.invoke_arn}"
}

output "s3-file-operations-lambda-invoke-arn" {
  value = "${aws_lambda_function.s3-file-operations-lambda.invoke_arn}"
}

output "optus-lambda-invoke-arn" {
  value = "${aws_lambda_function.optus-lambda.invoke_arn}"
}

output "optus-upload-lambda-invoke-arn" {
  value = "${aws_lambda_function.optus-upload-lambda.invoke_arn}"
}
output "lambda_depends_on_resource" {
  value = "${null_resource.dummy_dependency.id}"
}