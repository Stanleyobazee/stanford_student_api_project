.PHONY: start-db run-migrations build-api run-api stop-all status clean test deps fmt lint dev

# Load environment variables
include .env
export

# Start database container
start-db:
	@echo "🗄️  Starting PostgreSQL database container..."
	@if [ $$(docker ps -q -f name=stanford_student_api_project_postgres) ]; then \
		echo "✅ Database container already running"; \
	elif [ $$(docker ps -q -f ancestor=postgres) ]; then \
		echo "⚠️  Another PostgreSQL container is running. Skipping database start."; \
	else \
		docker-compose up -d postgres; \
		echo "⏳ Waiting for database to be ready..."; \
		sleep 10; \
	fi

# Run database migrations
run-migrations:
	@echo "🔄 Running database migrations..."
	@if [ -f ".migrations_applied" ]; then \
		echo "✅ Migrations already applied"; \
	else \
		docker run --rm --network host \
			-v $(PWD)/database/migrations:/migrations \
			migrate/migrate:latest \
			-path=/migrations \
			-database "postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@localhost:5433/$(POSTGRES_DB)?sslmode=disable" \
			up; \
		touch .migrations_applied; \
	fi

# Build REST API docker image
build-api:
	@echo "🏗️  Building REST API Docker image..."
	docker build -t stanford-students-api:latest .
	@echo "✅ Docker image built successfully!"

# Run REST API docker container (with dependencies)
run-api: start-db run-migrations build-api
	@echo "🚀 Starting REST API container..."
	@if [ $$(docker ps -q -f name=stanford_student_api_project_app) ]; then \
		echo "✅ API container already running at http://localhost:8080"; \
	elif lsof -i:8080 >/dev/null 2>&1; then \
		echo "⚠️  Port 8080 is already in use. Please stop the running application first."; \
		echo "🔍 Check what's running: lsof -i:8080"; \
	else \
		docker-compose up -d app; \
		echo "✅ API is running at http://localhost:8080"; \
		echo "🔍 Health check: http://localhost:8080/healthcheck"; \
	fi

# Stop all containers
stop-all:
	@echo "🛑 Stopping project containers..."
	@if [ $$(docker ps -q -f name=stanford_student_api_project) ]; then \
		docker-compose down; \
		rm -f .migrations_applied; \
		echo "✅ Project containers stopped"; \
	else \
		echo "ℹ️  No project containers running"; \
	fi

# Development targets
dev-local:
	@echo "🔧 Running API locally (requires local PostgreSQL)"
	go run main.go

# Build the application locally
build-local:
	go build -o bin/stanford-api main.go

# Run tests
test:
	go test -v ./tests/...

# Clean build artifacts and containers
clean:
	rm -rf bin/ postgres_data/ .migrations_applied
	docker-compose down -v
	docker rmi stanford-students-api:latest 2>/dev/null || true

# Install dependencies
deps:
	go mod tidy
	go mod download

# Format code
fmt:
	go fmt ./...

# Lint code
lint:
	golangci-lint run

# Check application status
status:
	@echo "📊 Stanford Students API Status:"
	@echo ""
	@if [ $$(docker ps -q -f name=stanford_student_api_project_postgres) ]; then \
		echo "🗄️  Database: ✅ Running (containerized)"; \
	elif [ $$(docker ps -q -f ancestor=postgres) ]; then \
		echo "🗄️  Database: ✅ Running (other container)"; \
	elif lsof -i:5432 >/dev/null 2>&1; then \
		echo "🗄️  Database: ✅ Running (local PostgreSQL)"; \
	else \
		echo "🗄️  Database: ❌ Not running"; \
	fi
	@if [ $$(docker ps -q -f name=stanford_student_api_project_app) ]; then \
		echo "🚀 API: ✅ Running (containerized)"; \
	elif lsof -i:8080 >/dev/null 2>&1; then \
		echo "🚀 API: ✅ Running (local/other)"; \
	else \
		echo "🚀 API: ❌ Not running"; \
	fi
	@echo ""
	@if lsof -i:8080 >/dev/null 2>&1; then \
		echo "🌐 Access: http://localhost:8080"; \
		echo "🔍 Health: http://localhost:8080/healthcheck"; \
	fi

# Show help
help:
	@echo "Stanford Students API - Available Make Targets:"
	@echo ""
	@echo "🐳 Docker Operations:"
	@echo "  start-db      - Start PostgreSQL database container"
	@echo "  run-migrations - Run database migrations"
	@echo "  build-api     - Build REST API Docker image"
	@echo "  run-api       - Start complete application (DB + API)"
	@echo "  stop-all      - Stop project containers"
	@echo "  status        - Check application status"
	@echo ""
	@echo "🔧 Development:"
	@echo "  dev-local     - Run API locally (requires local PostgreSQL)"
	@echo "  build-local   - Build application binary"
	@echo "  test          - Run unit tests"
	@echo "  clean         - Clean all artifacts and containers"
	@echo ""
	@echo "📋 Code Quality:"
	@echo "  deps          - Install/update dependencies"
	@echo "  fmt           - Format Go code"
	@echo "  lint          - Run code linter"
	@echo "  help          - Show this help message"
	@echo ""
	@echo "🚀 Quick Start: make run-api"