#!/bin/bash

echo "🔒 Security Cleanup Script for Stanford Students API"
echo "=================================================="

# Generate new secure credentials
echo "🔑 Generating new secure credentials..."
NEW_DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
NEW_VAULT_TOKEN=$(openssl rand -hex 32)

echo "✅ New credentials generated"

# Update Kubernetes secrets
echo "🔄 Updating Kubernetes secrets..."

# Update postgres secret
kubectl create secret generic postgres-secret \
  --from-literal=password="$NEW_DB_PASSWORD" \
  -n student-api \
  --dry-run=client -o yaml | kubectl apply -f -

# Update vault token secret
kubectl create secret generic vault-token \
  --from-literal=token="$NEW_VAULT_TOKEN" \
  -n student-api \
  --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Kubernetes secrets updated"

# Update Vault with new password
echo "🏦 Updating Vault with new credentials..."
VAULT_POD=$(kubectl get pods -n vault -l app=vault -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [[ -n "$VAULT_POD" ]]; then
    kubectl exec -n vault $VAULT_POD -- env VAULT_ADDR=http://127.0.0.1:8200 \
        vault kv put secret/database postgres_password="$NEW_DB_PASSWORD" 2>/dev/null || echo "⚠️  Vault update failed - manual update required"
    echo "✅ Vault updated"
else
    echo "⚠️  Vault pod not found - manual update required"
fi

# Restart deployments to pick up new secrets
echo "🔄 Restarting deployments..."
kubectl rollout restart deployment postgres -n student-api 2>/dev/null || echo "⚠️  Postgres deployment not found"
kubectl rollout restart deployment stanford-students-api -n student-api 2>/dev/null || echo "⚠️  API deployment not found"

echo ""
echo "🎉 Security cleanup completed!"
echo "📝 New credentials (save these securely):"
echo "   DB_PASSWORD=$NEW_DB_PASSWORD"
echo "   VAULT_ROOT_TOKEN=$NEW_VAULT_TOKEN"
echo ""
echo "⚠️  IMPORTANT: Update your .env file with these new credentials"
echo "⚠️  IMPORTANT: Verify all services are running after restart"