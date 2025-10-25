# Helm Deployment Guide

## Password Management Strategy

### Current Password Alignment
- **Development**: `admin12345` (default in values.yaml)
- **Production**: `admin12345` (aligned in values-production.yaml)
- **Secure Override**: Use environment variables or --set flags

### Deployment Options

#### Option 1: Use Default Password (Development)
```bash
helm install stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --create-namespace
```

#### Option 2: Generate Secure Password (Recommended)
```bash
# Generate secure password
export DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

# Deploy with secure password
helm install stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --create-namespace \
  --set postgresql.auth.postgresPassword="$DB_PASSWORD"

echo "Database password: $DB_PASSWORD"
```

#### Option 3: Use Existing Password (Migration)
```bash
# If migrating from existing K8s deployment
export EXISTING_PASSWORD="admin12345"

helm install stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --create-namespace \
  --set postgresql.auth.postgresPassword="$EXISTING_PASSWORD"
```

#### Option 4: Production Deployment
```bash
# Production with custom secure password
export PROD_DB_PASSWORD="your-super-secure-production-password"

helm install stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --create-namespace \
  --values values-production.yaml \
  --set postgresql.auth.postgresPassword="$PROD_DB_PASSWORD"
```

### Password Consistency Check

Before deployment, verify password alignment:

```bash
# Check current K8s secret (if exists)
kubectl get secret postgres-secret -n student-api -o jsonpath='{.data.password}' | base64 -d

# Check Helm values
helm get values stanford-students-api -n student-api
```

### Migration from K8s Manifests

If you have existing data with `admin12345`:

```bash
# 1. Backup existing data
kubectl exec -n student-api deployment/postgres -- pg_dump -U postgres stanford_students > backup.sql

# 2. Deploy Helm with same password
helm install stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --set postgresql.auth.postgresPassword="admin12345"

# 3. Restore data if needed
kubectl exec -i -n student-api deployment/stanford-students-api-postgresql -- psql -U postgres stanford_students < backup.sql
```

### Security Best Practices

1. **Never commit passwords to Git**
2. **Use environment variables for sensitive data**
3. **Rotate passwords regularly**
4. **Use Kubernetes secrets for production**
5. **Consider using External Secrets Operator with Vault**

### Troubleshooting Password Issues

#### Password Mismatch Error
```bash
# Check current password
kubectl get secret postgres-secret -n student-api -o yaml

# Update password
helm upgrade stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --set postgresql.auth.postgresPassword="correct-password"
```

#### Reset Password
```bash
# Generate new password and update
NEW_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

helm upgrade stanford-students-api ./stanford-students-api \
  --namespace student-api \
  --set postgresql.auth.postgresPassword="$NEW_PASSWORD"

echo "New password: $NEW_PASSWORD"
```