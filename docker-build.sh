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
    echo "docker run --network host -e DATABASE_URL='postgres://admin_stan:admin12345@localhost:5432/stanford_students_db?sslmode=disable' stanford-students-api:v1"

    echo ""
    echo "🐳 To run with CONTAINERIZED PostgreSQL (port 5433):"
    echo "docker-compose up -d"
    echo "📍 Container PostgreSQL will be available on localhost:5433"
    echo "📍 Local PostgreSQL remains on localhost:5432"
    echo "💾 Data will be persisted in ./postgres_data/ directory"
else
    echo "❌ Docker build failed!"
    exit 1
fi