data "aws_iam_role" "default" {
  name = "${var.app_name}-lambda"
}

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
  # Neccessary
  function_name        = var.ms_name
  package_type         = "Image"
  image_uri            = "${aws_ecr_repository.default.repository_url}:${var.tag}"
  role                 = data.aws_iam_role.default.arn
  publish              = true
  
  # Optional
  depends_on = [
    aws_ecr_repository.default,
    aws_cloudwatch_log_group.default
  ]
}

resource "aws_cloudwatch_log_group" "default" {
  name = "/aws/lambda/${var.ms_name}"

  retention_in_days = 30
}