resource "aws_secretsmanager_secret" "cloudtamer_api_key" {
    name                = "cloudtamer-api-key"
    description         = "CloudTamer API Token used by Patching"
    tags                = {}
    tags_all            = {}

    depends_on = [aws_lambda_function.ct_api_renewal]
}

resource "aws_secretsmanager_secret_rotation" "rotate_cloudtamer_api_key" {
  secret_id           = aws_secretsmanager_secret.cloudtamer_api_key.id
  rotation_lambda_arn = aws_lambda_function.ct_api_renewal.arn

  rotation_rules {
    automatically_after_days = 5
  }

  depends_on = [
    aws_secretsmanager_secret.cloudtamer_api_key,
    aws_lambda_permission.allow_secretsmanager,
    aws_lambda_function.ct_api_renewal
  ]
}