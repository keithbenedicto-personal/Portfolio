output "sea-hrz-online-cognito-authenticated-role" {
    value = "${aws_iam_role.sea-hrz-online-chatengine-auth-role.id}"
}

# iamrole for lambda
output "sea-hrz-online-lambda-iamrole-arn" {
    value = "${aws_iam_role.lambda-iamrole.arn}"
    #value = "arn:aws:iam::${var.aws_account_id}:role/service-role/${var.project_name}-lambda-iamrole-${var.env}"
    #value = "${var.project_name}-lambda-iamrole-${var.env}"
}

