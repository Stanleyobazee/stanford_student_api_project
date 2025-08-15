@echo off
echo 🔍 Stanford Students API - Debug and Fix Script
echo.

echo 📋 Checking system status...
echo.

echo 🐳 Docker Status:
docker --version 2>nul
if %errorlevel% neq 0 (
    echo ❌ Docker not found. Please install Docker Desktop.
    goto :end
)

echo ✅ Docker installed
echo.

echo 🔄 Checking Docker daemon...
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Desktop is not running
    echo 🚀 Starting Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo ⏳ Waiting for Docker Desktop to start (30 seconds)...
    timeout /t 30 /nobreak >nul
    
    echo 🔄 Checking Docker daemon again...
    docker ps >nul 2>&1
    if %errorlevel% neq 0 (
        echo ❌ Docker Desktop failed to start. Please start it manually.
        echo 📖 Instructions:
        echo    1. Open Docker Desktop from Start Menu
        echo    2. Wait for it to fully start
        echo    3. Run this script again
        goto :end
    )
)

echo ✅ Docker daemon is running
echo.

echo 🗄️ Starting PostgreSQL database...
docker compose up -d postgres
if %errorlevel% neq 0 (
    echo ❌ Failed to start database
    goto :end
)

echo ⏳ Waiting for database to be ready...
timeout /t 15 /nobreak >nul

echo 🔄 Running database migrations...
docker run --rm --network host -v "%cd%\database\migrations:/migrations" migrate/migrate:latest -path=/migrations -database "postgres://admin_stan:admin12345@localhost:5433/stanford_students?sslmode=disable" up
if %errorlevel% neq 0 (
    echo ⚠️ Migrations may have failed, but continuing...
)

echo 🏗️ Building API Docker image...
docker build -t stanford-students-api:latest .
if %errorlevel% neq 0 (
    echo ❌ Failed to build API image
    goto :end
)

echo 🚀 Starting API container...
docker compose up -d app
if %errorlevel% neq 0 (
    echo ❌ Failed to start API
    goto :end
)

echo.
echo ✅ Application started successfully!
echo 🌐 Web Interface: http://localhost:8080
echo 🔍 Health Check: http://localhost:8080/healthcheck
echo 📊 API Endpoints: http://localhost:8080/api/v1/students
echo.
echo 📋 To check status: docker compose ps
echo 🛑 To stop: docker compose down

:end
pause