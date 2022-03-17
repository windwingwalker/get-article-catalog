resource "aws_apigatewayv2_integration" "default" {
  api_id = var.api_id

  integration_uri    = var.lambda_function_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "default" {
  api_id = var.api_id

  route_key = "GET /article-index"
  target    = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_lambda_permission" "default" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_execution_arn}/*/*"
}