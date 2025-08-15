#!/bin/bash

echo "🔍 Stanford Students API - Debug and Fix Script (Ubuntu)"
echo

echo "📋 Checking system status..."
echo

# Check Docker
echo "🐳 Docker Status:"
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Installing..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "⚠️  Please logout and login again for Docker permissions"
    exit 1
fi

echo "✅ Docker installed: $(docker --version)"

# Check if Docker daemon is running
if ! docker ps &> /dev/null; then
    echo "🔄 Starting Docker daemon..."
    sudo systemctl start docker
    sleep 3
fi

if ! docker ps &> /dev/null; then
    echo "❌ Docker daemon not running. Please run: sudo systemctl start docker"
    exit 1
fi

echo "✅ Docker daemon is running"
echo

# Check Make
if ! command -v make &> /dev/null; then
    echo "📦 Installing Make..."
    sudo apt install -y make
fi

echo "✅ Make available: $(make --version | head -1)"
echo

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker compose down 2>/dev/null || true

# Clean up
echo "🧹 Cleaning up..."
rm -f .migrations_applied

echo "🗄️ Starting PostgreSQL database..."
docker compose up -d postgres

if [ $? -ne 0 ]; then
    echo "❌ Failed to start database"
    exit 1
fi

echo "⏳ Waiting for database to be ready..."
sleep 15

# Check if database is running
if ! docker compose ps | grep postgres | grep -q "Up"; then
    echo "❌ Database container failed to start"
    docker compose logs postgres
    exit 1
fi

echo "✅ Database is running"

echo "🔄 Running database migrations..."
docker run --rm --network host \
    -v "$(pwd)/database/migrations:/migrations" \
    migrate/migrate:latest \
    -path=/migrations \
    -database "postgres://admin_stan:admin12345@localhost:5433/stanford_students?sslmode=disable" \
    up

echo "🏗️ Building API Docker image..."
docker build -t stanford-students-api:latest .

if [ $? -ne 0 ]; then
    echo "❌ Failed to build API image"
    exit 1
fi

echo "🚀 Starting API container..."
docker compose up -d app

if [ $? -ne 0 ]; then
    echo "❌ Failed to start API"
    exit 1
fi

echo
echo "⏳ Waiting for API to start..."
sleep 10

# Check if API is responding
if curl -s http://localhost:8080/healthcheck > /dev/null; then
    echo "✅ Application started successfully!"
    echo "🌐 Web Interface: http://localhost:8080"
    echo "🔍 Health Check: http://localhost:8080/healthcheck"
    echo "📊 API Endpoints: http://localhost:8080/api/v1/students"
else
    echo "⚠️ API may not be fully ready yet. Check logs:"
    echo "docker compose logs app"
fi

echo
echo "📋 Container Status:"
docker compose ps

echo
echo "🔧 Useful commands:"
echo "  Check logs: docker compose logs app"
echo "  Stop all: docker compose down"
echo "  Restart: docker compose restart"