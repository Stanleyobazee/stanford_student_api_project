#!/bin/bash

# Stanford Students API Kubernetes Deployment Script
echo "🚀 Deploying Stanford Students API to Kubernetes..."

# Set kubectl context to minikube cluster
kubectl config use-context stanford-students-cluster

# Deploy namespaces first
echo "📁 Creating namespaces..."
kubectl apply -f k8s/manifests/namespace.yml

# Install External Secrets Operator
echo "🔐 Installing External Secrets Operator..."
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace

# Deploy Vault
echo "🏦 Deploying HashiCorp Vault..."
kubectl apply -f k8s/manifests/vault.yml

# Wait for Vault to be ready
echo "⏳ Waiting for Vault to be ready..."
kubectl wait --for=condition=ready pod -l app=vault -n vault --timeout=300s

# Setup Vault secrets
echo "🔧 Setting up Vault secrets..."
chmod +x k8s/vault/setup-vault.sh
./k8s/vault/setup-vault.sh

# Deploy External Secrets configuration
echo "🔗 Configuring External Secrets..."
kubectl apply -f k8s/manifests/external-secrets.yml

# Deploy database
echo "🗄️ Deploying PostgreSQL database..."
kubectl apply -f k8s/manifests/database.yml

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n student-api --timeout=300s

# Deploy application
echo "🚀 Deploying Stanford Students API..."
kubectl apply -f k8s/manifests/application.yml

# Wait for application to be ready
echo "⏳ Waiting for application to be ready..."
kubectl wait --for=condition=ready pod -l app=stanford-students-api -n student-api --timeout=300s

# Get service information
echo "📋 Deployment Summary:"
echo "===================="
kubectl get pods -n student-api
echo ""
kubectl get services -n student-api
echo ""
echo "🌐 API Access:"
echo "External URL: http://$(minikube ip --profile stanford-students-cluster):30080"
echo "Health Check: http://$(minikube ip --profile stanford-students-cluster):30080/healthcheck"
echo ""
echo "✅ Deployment completed successfully!"