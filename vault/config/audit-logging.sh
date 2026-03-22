#!/bin/bash
# vault/config/audit-logging.sh
# Enables Vault audit logging — required for SOC 2 and HIPAA compliance evidence

# Enable file-based audit log
vault audit enable file file_path=/vault/audit/audit.log

# Verify audit is enabled
vault audit list

# Every credential request is logged with:
# - request.time: exact timestamp
# - auth.display_name: the service account that requested
# - request.path: aws/creds/cicd-deploy
# - response.data: the IAM user created (not the secret values)