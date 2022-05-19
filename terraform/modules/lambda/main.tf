resource "aws_ecr_repository" "default" {
  name                 = var.ms_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_lambda_alias" "default" {
  name             = "dev"
  function_name    = aws_lambda_function.default.arn
  function_version = aws_lambda_function.default.version
}

resource "aws_lambda_function" "default" {
  function_name = var.ms_name

  package_type = "Image"
  image_uri = "${aws_ecr_repository.default.repository_url}:${var.tag}"

  role = var.lambda_role
  depends_on = [
    aws_ecr_repository.default,
    aws_cloudwatch_log_group.default
  ]
  publish = true

  environment {
    variables = {
      RESOURCE_NAME = var.resource_name
    }
  }
}

resource "aws_cloudwatch_log_group" "default" {
  name = "/aws/lambda/${var.ms_name}"

  retention_in_days = 30
}