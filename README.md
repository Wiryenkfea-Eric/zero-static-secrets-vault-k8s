# Zero Static Secrets: Vault Dynamic AWS Credentials in Kubernetes CI/CD

Production-tested architecture for eliminating static AWS IAM keys from
Kubernetes CI/CD pipelines using HashiCorp Vault dynamic secrets.

![Vault](https://img.shields.io/badge/HashiCorp-Vault-purple)
![Kubernetes](https://img.shields.io/badge/Kubernetes-K8s-blue)
![AWS](https://img.shields.io/badge/AWS-IAM-orange)
![License](https://img.shields.io/badge/License-Apache%202.0-green)

## Architecture

![Zero Static Secrets — CI/CD with HashiCorp Vault on Kubernetes](docs/architecture.png)

## How it works

1. GitHub Actions runner authenticates to Vault using a Kubernetes service account JWT
2. Vault validates the identity, checks the policy, and calls AWS to create a temporary IAM user
3. Vault returns the credentials to the pipeline — valid for 15 minutes only
4. The pipeline deploys to AWS (ECR, S3, EC2) using those credentials
5. Credentials auto-expire and the IAM user is deleted — no manual rotation ever needed

## The problem this solves

Static AWS IAM keys get committed to repos, embedded in CI/CD secrets, rotated
infrequently, and when compromised they hand attackers long-lived broad access.
This architecture eliminates static keys entirely — every credential is generated
on demand, scoped to exactly what the pipeline needs, and expires automatically.

## Repository structure

- `vault/helm-values/` — Helm values for HA Vault deployment on Kubernetes (3-node Raft)
- `vault/policies/` — Vault policy HCL (least-privilege, version-controlled)
- `vault/config/` — AWS secrets engine and audit logging configuration
- `kubernetes/auth/` — Kubernetes auth method setup and service account
- `github-actions/` — GitHub Actions workflow using hashicorp/vault-action
- `iam/` — IAM role and permission boundary for Vault root user
- `docs/` — Architecture diagram and compliance mapping

## Prerequisites

- Kubernetes cluster (minikube or EKS)
- Helm 3.x
- AWS CLI configured with IAM permissions
- kubectl

## Quick start
```bash
# 1. Deploy Vault
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault --namespace vault --create-namespace \
  --values vault/helm-values/production.yaml

# 2. Initialize and unseal
kubectl exec -n vault vault-0 -- vault operator init -key-shares=5 -key-threshold=3
kubectl exec -n vault vault-0 -- vault operator unseal <KEY>

# 3. Configure AWS secrets engine
# See vault/config/aws-secrets-engine.sh

# 4. Apply policy
vault policy write cicd-deploy-policy vault/policies/cicd-deploy-policy.hcl
```

## Compliance

This architecture satisfies:
- **HIPAA** 164.312 — unique user ID, audit controls, automatic session termination
- **SOC 2** CC6.1 — least-privilege access, automated revocation, audit evidence
- **HITRUST** 01.a — policy-as-code access control, TTL-enforced expiry

See [docs/compliance-mapping.md](docs/compliance-mapping.md) for the full mapping.

## HashiConf @ IBM TechXchange 2026

This repository supports the session submission:

**Zero Static Secrets: Replacing AWS IAM Keys with Vault Dynamic Credentials
in Production Kubernetes CI/CD**

- Conference: HashiConf @ IBM TechXchange 2026 — Atlanta, Georgia — October 26–29
- Track: Security & Governance
- Speaker: Eric Nyuydze Wiryenkfea — Cloud & DevOps Engineer 
- Community: AWS Community Builder, Co-organizer-HashiCorp User Group Accra (HUG Accra)
