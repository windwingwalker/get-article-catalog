terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
 
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "lambda" {
  source = "./modules/lambda/"
  app_name = var.app_name
  lambda_role = var.lambda_role
  tag = var.tag
}

module "api" {
  source = "./modules/api/"
  app_name = var.app_name
  lambda_function_invoke_arn = module.lambda.function_invoke_arn
  lambda_function_name = module.lambda.function_name
  api_id = var.api_id
  api_execution_arn = var.api_execution_arn
}