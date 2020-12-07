output "ui_api_invoke_url" {
  value = "${aws_api_gateway_deployment.ui-api-deployment.rest_api_id}"
}
output "chat_engine_backend_invoke_url" {
  value = "${aws_api_gateway_deployment.chat-engine-backend-deployment.rest_api_id}"
}
output "api_integrator_invoke_url" {
  value = "${aws_api_gateway_deployment.api-integrator-deployment.rest_api_id}"
}
output "s3_file_ops_invoke_url" {
  value = "${aws_api_gateway_deployment.s3-file-ops-deployment.rest_api_id}"
}
output "twilio_endpoint_invoke_url" {
  value = "${aws_api_gateway_deployment.twilio-endpoint-deployment.rest_api_id}"
}
