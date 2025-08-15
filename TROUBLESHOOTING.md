# Troubleshooting Guide

## Quick Fix for Current Issues

### Issue 1: Docker Compose Command Not Found
**Problem**: `docker-compose` command fails
**Solution**: Updated Makefile to use `docker compose` (newer syntax)

### Issue 2: Docker Desktop Not Running
**Problem**: Cannot connect to Docker daemon
**Solution**: 
1. Start Docker Desktop manually from Start Menu
2. Wait for it to fully load (whale icon in system tray)
3. Run the debug script: `debug-fix.bat`

### Issue 3: Application Not Accessible
**Problem**: API shows success but not accessible in browser
**Solution**: Check if containers are actually running

## Quick Commands

```bash
# Check if Docker Desktop is running
docker ps

# Start Docker Desktop (if not running)
# Open Docker Desktop from Start Menu

# Run the complete fix
debug-fix.bat

# Check container status
docker compose ps

# View logs
docker compose logs app
docker compose logs postgres

# Stop everything
docker compose down
```

## Manual Step-by-Step Fix

1. **Start Docker Desktop**
   - Open Docker Desktop from Windows Start Menu
   - Wait for the whale icon to appear in system tray

2. **Start Database**
   ```bash
   docker compose up -d postgres
   ```

3. **Wait and Check Database**
   ```bash
   # Wait 15 seconds
   docker compose ps
   ```

4. **Run Migrations**
   ```bash
   docker run --rm --network host -v "%cd%\database\migrations:/migrations" migrate/migrate:latest -path=/migrations -database "postgres://admin_stan:admin12345@localhost:5433/stanford_students?sslmode=disable" up
   ```

5. **Build and Start API**
   ```bash
   docker build -t stanford-students-api:latest .
   docker compose up -d app
   ```

6. **Verify Everything is Running**
   ```bash
   docker compose ps
   ```

## Expected Output

When everything works correctly:
- Database container: `stanford_student_api_project_postgres_1` (running)
- API container: `stanford_student_api_project_app_1` (running)
- Web interface accessible at: http://localhost:8080
- Health check responds at: http://localhost:8080/healthcheck

## Common Port Issues

If port 8080 is busy:
```bash
# Check what's using port 8080
netstat -ano | findstr :8080

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

## Database Connection Issues

If database connection fails:
1. Verify credentials in `.env` file
2. Check if database container is running: `docker compose ps`
3. Check database logs: `docker compose logs postgres`
4. Verify port 5433 is not in use: `netstat -ano | findstr :5433`