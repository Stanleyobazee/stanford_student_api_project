#!/bin/bash

# Secure Vault Setup Script for Stanford Students API
echo "🔐 Setting up HashiCorp Vault for Stanford Students API..."

# Check for required environment variables
if [[ -z "$VAULT_ROOT_TOKEN" ]]; then
    echo "⚠️  VAULT_ROOT_TOKEN not set. Generating secure token..."
    export VAULT_ROOT_TOKEN=$(openssl rand -hex 32)
    echo "🔑 Generated Vault token: $VAULT_ROOT_TOKEN"
fi

if [[ -z "$DB_PASSWORD" ]]; then
    echo "⚠️  DB_PASSWORD not set. Generating secure password..."
    export DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    echo "🔐 Generated DB password: $DB_PASSWORD"
fi

# Wait for Vault to be ready
echo "⏳ Waiting for Vault to be ready..."
kubectl wait --for=condition=ready pod -l app=vault -n vault --timeout=300s

# Get Vault pod name
VAULT_POD=$(kubectl get pods -n vault -l app=vault -o jsonpath='{.items[0].metadata.name}')
echo "📦 Vault pod: $VAULT_POD"

# Enable KV secrets engine
echo "🔧 Enabling KV secrets engine..."
kubectl exec -n vault $VAULT_POD -- env VAULT_ADDR=http://127.0.0.1:8200 vault secrets enable -path=secret kv-v2 2>/dev/null || echo "KV engine already enabled"

# Create database secret using environment variable
echo "🗄️ Creating database secrets..."
kubectl exec -n vault $VAULT_POD -- env VAULT_ADDR=http://127.0.0.1:8200 vault kv put secret/database \
  postgres_password="$DB_PASSWORD"

# Create vault token secret using environment variable
echo "🎫 Creating vault token secret..."
kubectl create secret generic vault-token \
  --from-literal=token="$VAULT_ROOT_TOKEN" \
  -n student-api \
  --dry-run=client -o yaml | kubectl apply -f -

# Update Kubernetes postgres secret
echo "🔄 Updating Kubernetes postgres secret..."
kubectl create secret generic postgres-secret \
  --from-literal=password="$DB_PASSWORD" \
  -n student-api \
  --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Vault setup completed securely!"
echo "🌐 Vault UI available at: http://localhost:8200 (use 'kubectl port-forward')"
echo "🔐 Credentials have been securely generated and stored"