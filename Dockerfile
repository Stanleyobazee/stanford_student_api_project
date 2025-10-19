# Build stage
FROM golang:1.21-alpine AS builder

# Install git and migrate tool
RUN apk add --no-cache git curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-amd64.tar.gz | tar xvz
RUN mv migrate /usr/local/bin/migrate

WORKDIR /app

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application with optimizations and timeout protection
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    timeout 300 go build \
    -ldflags='-w -s -extldflags "-static"' \
    -o main . || \
    (echo "Build timed out, trying simpler build..." && \
     CGO_ENABLED=0 go build -o main .)

# Final stage - using distroless for security
FROM gcr.io/distroless/static-debian11:nonroot

# Copy the binary and required files
COPY --from=builder /app/main /app/main
COPY --from=builder /app/web /app/web
COPY --from=builder /app/database /app/database
COPY --from=builder /usr/local/bin/migrate /usr/local/bin/migrate

# Set working directory
WORKDIR /app

# Expose port
EXPOSE 8080

# Use non-root user
USER nonroot:nonroot

# Health check removed - distroless doesn't have curl/wget
# Use external monitoring or docker-compose health check instead

# Run the application
ENTRYPOINT ["/app/main"]