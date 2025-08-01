.PHONY: build run test clean migrate-up migrate-down

# Build the application
build:
	go build -o bin/stanford-api main.go

# Run the application
run:
	go run main.go

# Run tests
test:
	go test -v ./tests/...

# Clean build artifacts
clean:
	rm -rf bin/

# Run database migrations up
migrate-up:
	migrate -path database/migrations -database "$(DATABASE_URL)" up

# Run database migrations down
migrate-down:
	migrate -path database/migrations -database "$(DATABASE_URL)" down

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

# Run application with hot reload (requires air)
dev:
	air