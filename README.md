# Get Article Index

## Terraform Import
There resources needed to import from other existing terraform resources
- `terraform import module.lambda.aws_iam_role.<local-name> <role-name>`
- `terraform import module.api.aws_apigatewayv2_api.<local-name> <api-id>`