data "aws_lambda_function" "default" {
  function_name = var.app_name
}

data "aws_api_gateway_rest_api" "default" {
  name = "article-gateway"
}

data "aws_api_gateway_resource" "default" {
  rest_api_id = data.aws_api_gateway_rest_api.default.id
  path        = "/article-index"
}

resource "aws_api_gateway_method" "get" {
  http_method   = "GET"
  authorization = "NONE"
  resource_id   = data.aws_api_gateway_resource.default.id
  rest_api_id   = data.aws_api_gateway_rest_api.default.id
}

resource "aws_api_gateway_integration" "get" {
  rest_api_id             = data.aws_api_gateway_rest_api.default.id
  resource_id             = data.aws_api_gateway_resource.default.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${data.aws_lambda_function.default.arn}:$${stageVariables.alias}/invocations"

  depends_on              = [aws_api_gateway_method.get]
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.app_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${data.aws_api_gateway_rest_api.default.execution_arn}/*/*"
}

resource "aws_api_gateway_method_response" "get_200" {
  rest_api_id = data.aws_api_gateway_rest_api.default.id
  resource_id = data.aws_api_gateway_resource.default.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = 200
}