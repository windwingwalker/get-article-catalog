pipeline{
  agent any
  environment {
    AWS_ACCESS_KEY_ID          = credentials('aws_access_key_id')
    AWS_SECRET_ACCESS_KEY      = credentials('aws_secret_access_key')
    AWS_ACCOUNT_ID             = credentials('aws_account_id')
    AWS_ECR_PASSWORD           = credentials('aws_ecr_password')
    APP_NAME                   = "get-article-index"
    TF_VAR_lambda_role         = "arn:aws:iam::${AWS_ACCOUNT_ID}:role/article-lambda"
    TF_VAR_api_id              = "fbl8mpj7g7"
    TF_VAR_api_execution_arn   = "arn:aws:execute-api:us-east-1:${AWS_ACCOUNT_ID}:${TF_VAR_api_id}"
    TF_VAR_tag                 = "${env.BUILD_NUMBER}"
  }
  tools {
    terraform 'TerraformDefault'
  }
  options {
    ansiColor('xterm')
  }
  stages{
    stage('Compile TS to JS'){
      agent {
        docker {
          image 'node:14-buster'
          reuseNode true
        }
      }
      steps{
        dir('dist'){}
        sh 'npm install'
        sh 'npm run build'
        stash includes: 'dist/**/*', name: 'distJs'
      }
    }
    stage('Docker build & push'){
      steps{
        sh 'ls -al'
        dir('dist'){
          unstash 'distJs'
        }
        sh 'docker login --username AWS --password ${AWS_ECR_PASSWORD} ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com'
        sh 'docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${APP_NAME}:${TF_VAR_tag} .'
        sh 'docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${APP_NAME}:${TF_VAR_tag}'
      }
    }
    stage('Terraform Apply'){
      steps{
        dir('terraform'){
          sh 'terraform init -input=false'
          sh 'terraform plan -out=tfplan -input=false'
          sh 'terraform apply -input=false -auto-approve tfplan'
        }
        sh 'rm -rf dist/' 
      }
    }
  }
}