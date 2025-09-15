#!/bin/bash

# Vault Setup Script for Stanford Students API
echo "🔐 Setting up HashiCorp Vault for Stanford Students API..."

# Wait for Vault to be ready
echo "⏳ Waiting for Vault to be ready..."
kubectl wait --for=condition=ready pod -l app=vault -n vault --timeout=300s

# Get Vault pod name
VAULT_POD=$(kubectl get pods -n vault -l app=vault -o jsonpath='{.items[0].metadata.name}')
echo "📦 Vault pod: $VAULT_POD"

# Enable KV secrets engine
echo "🔧 Enabling KV secrets engine..."
kubectl exec -n vault $VAULT_POD -- vault secrets enable -path=secret kv-v2

# Create database secret
echo "🗄️ Creating database secrets..."
kubectl exec -n vault $VAULT_POD -- vault kv put secret/database \
  postgres_password="your_secure_password_123"

# Create vault token secret for External Secrets Operator
echo "🎫 Creating vault token secret..."
kubectl create secret generic vault-token \
  --from-literal=token=root-token \
  -n student-api

echo "✅ Vault setup completed!"
echo "🌐 Vault UI available at: http://localhost:8200 (use 'kubectl port-forward')"
echo "🔑 Root token: root-token"