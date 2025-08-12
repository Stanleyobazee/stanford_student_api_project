#!/bin/bash

# Stanford Students API - Docker Build Script

echo "🏗️  Building Stanford Students API Docker Image..."

# Build the Docker image
docker build -t stanford-students-api:v1 .

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo "📊 Image details:"
    docker images stanford-students-api:v1
    
    echo ""
    echo "🚀 To run with LOCAL PostgreSQL (port 5432):"
    echo "docker run -p 8080:8080 -e DATABASE_URL='postgres://admin_stan:password123@host.docker.internal:5432/stanford_students_db?sslmode=disable' stanford-students-api:v1"

    echo ""
    echo "🐳 To run with CONTAINERIZED PostgreSQL (port 5433):"
    echo "docker-compose up -d"
    echo "📍 Container PostgreSQL will be available on localhost:5433"
    echo "📍 Local PostgreSQL remains on localhost:5432"
else
    echo "❌ Docker build failed!"
    exit 1
fi