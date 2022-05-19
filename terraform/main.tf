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
  default_tags {
    tags = {
      "app" = var.app_name
    }
  }
}

module "lambda" {
  source = "./modules/lambda/"
  ms_name = var.ms_name
  resource_name = var.resource_name
  lambda_role = var.lambda_role
  tag = var.tag
}

module "api" {
  source = "./modules/api/"
  ms_name = var.ms_name
  app_name = var.app_name
  resource_name = var.resource_name
  aws_region = var.aws_region
  function_arn = module.lambda.function_arn
}