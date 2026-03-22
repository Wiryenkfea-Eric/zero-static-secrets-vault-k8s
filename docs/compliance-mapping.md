# Compliance Mapping: Zero Static Secrets Architecture

How this architecture satisfies HIPAA, SOC 2, and HITRUST requirements.

## HIPAA Security Rule — Technical Safeguards

| Control | Requirement | How Vault Satisfies It |
|---------|-------------|------------------------|
| 164.312(a)(2)(i) | Unique user identification | Each pipeline gets a unique dynamic IAM user per run |
| 164.312(b) | Audit controls | Vault audit log records every credential request with timestamp and identity |
| 164.312(d) | Authentication | Kubernetes service account JWT + Vault role binding |

## SOC 2 — CC6.1 Logical Access

- **Least privilege**: each pipeline role gets only the IAM actions it needs
- **Access revocation**: credentials expire automatically after 15 minutes — no manual rotation
- **Audit evidence**: Vault audit log + CloudTrail = complete access record for reviewers

## HITRUST — Control 01.a Access Control Policy

- Dynamic credentials = no persistent access keys in any system
- TTL-enforced expiry = automatic revocation without human intervention
- Policy-as-code (HCL) = auditable, version-controlled access control

## Audit Evidence Package for Compliance Reviewers

1. `vault audit list` output — proves audit logging is enabled
2. Sample Vault audit log entry — shows credential request and issuance
3. `vault policy read cicd-deploy-policy` — proves least-privilege design
4. CloudTrail events — shows short-lived IAM user creation and deletion
5. IAM Credential Report — confirms zero long-lived keys in CI/CD accounts

## Before vs After

| | Before (Static Keys) | After (Vault Dynamic) |
|--|----------------------|----------------------|
| Credential lifetime | Months/years | 15 minutes |
| Rotation | Manual, often skipped | Automatic on every run |
| Audit trail | CloudTrail only | Vault audit + CloudTrail |
| Blast radius if leaked | Full account access until rotated | Expires in minutes |
| SOC 2 / HIPAA evidence | Difficult to produce | Built into every request |