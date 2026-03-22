# vault/policies/cicd-deploy-policy.hcl
# Least-privilege policy for CI/CD runners

# Allow reading dynamic AWS credentials
path "aws/creds/cicd-deploy" {
  capabilities = ["read"]
}

# Allow renewing own token
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Allow looking up own token
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Explicit deny everything else
path "secret/*" {
  capabilities = ["deny"]
}

path "sys/*" {
  capabilities = ["deny"]
}