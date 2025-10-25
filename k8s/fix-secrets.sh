#!/bin/bash

echo "🔧 Fixing External Secrets Operator and Vault integration..."

# Install External Secrets Operator with CRDs
echo "📦 Installing External Secrets Operator with CRDs..."
kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/crds/bundle.yaml

# Wait for CRDs to be ready
echo "⏳ Waiting for CRDs to be installed..."
sleep 10

# Install ESO
kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/charts/external-secrets/templates/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/charts/external-secrets/templates/deployment.yaml

# Create a secure secret (fallback)
echo "🔑 Creating secure postgres secret..."
SECURE_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
kubectl create secret generic postgres-secret \
  --from-literal=password="$SECURE_PASSWORD" \
  -n student-api \
  --dry-run=client -o yaml | kubectl apply -f -
echo "✅ Generated secure password: $SECURE_PASSWORD"

echo "✅ Secrets setup completed!"