output "function_name" {  
  description = "Name of the Lambda function."
  value = aws_lambda_function.default.function_name
}

output "function_invoke_arn" {  
  description = "Arn of the Lambda function."
  value = aws_lambda_function.default.invoke_arn
}

output "ecr_uri" {
  value = aws_ecr_repository.default.repository_url
}



