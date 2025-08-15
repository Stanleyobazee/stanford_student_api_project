#!/bin/bash

# Stanford Students API - Quick Start Script
# One-command setup and run for team members

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
echo "🚀 Stanford Students API - Quick Start"
echo "====================================="
echo -e "${NC}"

# Check if setup script exists
if [ ! -f "setup.sh" ]; then
    echo -e "${YELLOW}⚠️  setup.sh not found. Please run this script from the project root directory.${NC}"
    exit 1
fi

# Make setup script executable
chmod +x setup.sh

# Run setup
echo -e "${BLUE}📦 Installing required tools...${NC}"
./setup.sh "$@"

echo ""
echo -e "${BLUE}🔧 Starting the application...${NC}"

# Check if .env exists and has required variables
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Creating from template...${NC}"
    cp .env.example .env
fi

# Check if POSTGRES_PASSWORD is set
if ! grep -q "POSTGRES_PASSWORD=" .env || grep -q "POSTGRES_PASSWORD=$" .env; then
    echo -e "${YELLOW}⚠️  Please set POSTGRES_PASSWORD in .env file${NC}"
    echo "Example: POSTGRES_PASSWORD=your_secure_password"
    echo ""
    echo "Edit .env file and run: make run-api"
    exit 1
fi

# Start the application
echo -e "${GREEN}🚀 Starting Stanford Students API...${NC}"
make run-api

echo ""
echo -e "${GREEN}✅ Application is running!${NC}"
echo ""
echo "🌐 Web Interface: http://localhost:8080"
echo "🔍 Health Check: http://localhost:8080/healthcheck"
echo "📚 API Docs: http://localhost:8080/api/v1/students"
echo ""
echo "To stop: make stop-all"
echo "To check status: make status"