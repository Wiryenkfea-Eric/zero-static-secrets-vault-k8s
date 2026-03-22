#!/bin/bash
# kubernetes/auth/vault-auth-setup.sh

vault auth enable kubernetes

vault write auth/kubernetes/config \
  kubernetes_host=https://kubernetes.default.svc.cluster.local:443 \
  disable_local_ca_jwt=false

vault write auth/kubernetes/role/cicd-runner \
  bound_service_account_names=github-actions-runner \
  bound_service_account_namespaces=cicd \
  policies=cicd-deploy-policy \
  ttl=1h