# Ubuntu Quick Fix Guide

## Run These Commands

```bash
# Make script executable
chmod +x debug-fix.sh

# Run the fix script
./debug-fix.sh
```

## Manual Fix Steps

```bash
# 1. Stop existing containers
docker compose down

# 2. Start database
docker compose up -d postgres

# 3. Wait for database
sleep 15

# 4. Run migrations
docker run --rm --network host \
    -v "$(pwd)/database/migrations:/migrations" \
    migrate/migrate:latest \
    -path=/migrations \
    -database "postgres://admin_stan:admin12345@localhost:5433/stanford_students?sslmode=disable" \
    up

# 5. Build API
docker build -t stanford-students-api:latest .

# 6. Start API
docker compose up -d app

# 7. Check status
docker compose ps
curl http://localhost:8080/healthcheck
```

## If Docker Permission Issues

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Access Application

- Web: http://localhost:8080
- Health: http://localhost:8080/healthcheck
- API: http://localhost:8080/api/v1/students