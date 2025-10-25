#!/bin/bash

# Stanford Students API Helm Deployment Script
echo "🚀 Deploying Stanford Students API using Helm Charts..."

# Set kubectl context to minikube cluster
kubectl config use-context stanford-students-cluster

# Add required Helm repositories
echo "📦 Adding Helm repositories..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

# Create namespaces first
echo "📁 Creating namespaces..."
kubectl create namespace student-api --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace vault --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace external-secrets-system --dry-run=client -o yaml | kubectl apply -f -

# Update dependencies
echo "🔄 Updating Helm dependencies..."
cd stanford-students-api
helm dependency update
cd ..

# Generate secure credentials if not provided
if [[ -z "$DB_PASSWORD" ]]; then
    echo "🔐 Generating secure database password..."
    export DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    echo "✅ Generated secure database password"
fi

if [[ -z "$VAULT_TOKEN" ]]; then
    echo "🔐 Generating secure Vault token..."
    export VAULT_TOKEN=$(openssl rand -hex 32)
    echo "✅ Generated secure Vault token"
fi

# Deploy the complete stack using Helm
echo "🚀 Deploying Stanford Students API stack..."
helm upgrade --install stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --create-namespace \
  --set postgresql.auth.postgresPassword="$DB_PASSWORD" \
  --set vault.server.dev.devRootToken="$VAULT_TOKEN" \
  --wait \
  --timeout 10m

echo ""
echo "🔑 IMPORTANT: Save these credentials securely!"
echo "Database Password: $DB_PASSWORD"
echo "Vault Token: $VAULT_TOKEN"
echo "⚠️  These credentials are required for accessing your services"

# Wait for all pods to be ready
echo "⏳ Waiting for all pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stanford-students-api -n student-api --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql -n student-api --timeout=300s

# Get deployment status
echo "📋 Deployment Summary:"
echo "===================="
helm list -n student-api
echo ""
kubectl get pods -n student-api
echo ""
kubectl get services -n student-api
echo ""

# Get access information
echo "🌐 API Access:"
echo "External URL: http://$(minikube ip --profile stanford-students-cluster):30080"
echo "Health Check: http://$(minikube ip --profile stanford-students-cluster):30080/healthcheck"
echo ""

# Show Helm release information
echo "📊 Helm Release Information:"
helm status stanford-students-api -n student-api

echo "✅ Helm deployment completed successfully!"
echo "🎯 Use 'helm upgrade' to update the deployment"
echo "🗑️  Use 'helm uninstall stanford-students-api -n student-api' to remove"