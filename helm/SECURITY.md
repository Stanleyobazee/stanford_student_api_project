# Security Guidelines for Helm Deployment

## 🔒 Password Security

### ❌ NEVER DO THIS:
- Commit real passwords to Git
- Use default passwords in production
- Share credentials in plain text
- Store secrets in values files that go to Git

### ✅ ALWAYS DO THIS:
- Use environment variables for secrets
- Generate secure random passwords
- Override default values during deployment
- Keep local values files out of Git

## 🛡️ Secure Deployment Methods

### Method 1: Environment Variables (Recommended)
```bash
export DB_PASSWORD=$(openssl rand -base64 32)
export VAULT_TOKEN=$(openssl rand -hex 32)

helm install stanford-students-api ./stanford-students-api \
  --set postgresql.auth.postgresPassword="$DB_PASSWORD" \
  --set vault.server.dev.devRootToken="$VAULT_TOKEN"
```

### Method 2: Local Values File (Not in Git)
```bash
# Create values-local.yaml (excluded from Git)
cp values-local.yaml.example values-local.yaml
# Edit values-local.yaml with real passwords

helm install stanford-students-api ./stanford-students-api \
  --values values-local.yaml
```

### Method 3: Kubernetes Secrets (Production)
```bash
# Create secret first
kubectl create secret generic app-secrets \
  --from-literal=db-password="$(openssl rand -base64 32)" \
  --from-literal=vault-token="$(openssl rand -hex 32)"

# Reference in Helm values
helm install stanford-students-api ./stanford-students-api \
  --set postgresql.auth.existingSecret="app-secrets"
```

## 🔐 What's Safe to Commit

### ✅ Safe Files (Public):
- `values.yaml` - With placeholder passwords
- `values-production.yaml` - With placeholder passwords  
- `values-local.yaml.example` - Template only
- All template files
- Chart.yaml

### ❌ Never Commit:
- `values-local.yaml` - Contains real passwords
- `values-dev.yaml` - Contains real passwords
- `values-prod.yaml` - Contains real passwords
- Any file with actual credentials

## 🚨 Emergency: If Secrets Were Committed

### Immediate Actions:
1. **Rotate all exposed credentials immediately**
2. **Remove from Git history**
3. **Update .gitignore**
4. **Force push cleaned history**

```bash
# Remove from Git history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch helm/values-local.yaml' \
  --prune-empty --tag-name-filter cat -- --all

# Force push
git push origin --force --all
```

## 🔄 Credential Rotation

### Regular Rotation (Monthly):
```bash
# Generate new credentials
NEW_DB_PASSWORD=$(openssl rand -base64 32)
NEW_VAULT_TOKEN=$(openssl rand -hex 32)

# Update deployment
helm upgrade stanford-students-api ./stanford-students-api \
  --set postgresql.auth.postgresPassword="$NEW_DB_PASSWORD" \
  --set vault.server.dev.devRootToken="$NEW_VAULT_TOKEN"
```

## 📋 Security Checklist

Before pushing to Git:
- [ ] No real passwords in any committed files
- [ ] All secrets use placeholder values
- [ ] .gitignore excludes local values files
- [ ] Security comments added to values files
- [ ] Local development uses values-local.yaml (not committed)

## 🎯 Production Security

For production deployments:
- Use external secret management (Vault, AWS Secrets Manager)
- Implement proper RBAC
- Enable audit logging
- Use network policies
- Regular security scans
- Automated credential rotation