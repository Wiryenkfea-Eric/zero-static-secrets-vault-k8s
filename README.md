# Zero Static Secrets: Vault Dynamic AWS Credentials in Kubernetes CI/CD

Production-tested architecture for eliminating static AWS IAM keys from
Kubernetes CI/CD pipelines using HashiCorp Vault dynamic secrets.

Built and presented at HashiConf @ IBM TechXchange 2026.

## Architecture
GitHub Actions → Vault (K8s Auth) → AWS Secrets Engine → Short-lived IAM creds

## Repository Structure
- vault/         Helm values, policies, config
- kubernetes/    Service accounts and auth manifests
- github-actions/ Workflow YAML examples
- iam/           IAM role and boundary templates
- docs/          Architecture diagram and compliance mapping

## Talk: HashiConf @ IBM TechXchange 2026
Session: Zero Static Secrets — Security & Governance Track
