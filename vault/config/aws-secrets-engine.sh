#!/bin/bash
# vault/config/aws-secrets-engine.sh
# Run these commands to configure the AWS Secrets Engine

# Enable the AWS secrets engine
vault secrets enable -path=aws aws

# Configure root credentials
vault write aws/config/root \
  access_key=$AWS_ACCESS_KEY_ID \
  secret_key=$AWS_SECRET_ACCESS_KEY \
  region=us-east-1

# Create CI/CD deploy role — 15 min TTL, S3 and ECR permissions only
vault write aws/roles/cicd-deploy \
  credential_type=iam_user \
  default_ttl=15m \
  max_ttl=1h \
  policy_document='{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": ["s3:PutObject","s3:GetObject","ecr:GetAuthorizationToken",
                 "ecr:BatchCheckLayerAvailability","ecr:PutImage"],
      "Resource": "*"
    }]
  }'

# Test it
vault read aws/creds/cicd-deploy