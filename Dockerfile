# Build stage
FROM golang:1.21-alpine AS builder

# Install git for go mod download
RUN apk add --no-cache git

WORKDIR /app

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application with optimizations
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' \
    -a -installsuffix cgo \
    -o main .

# Final stage - using distroless for security
FROM gcr.io/distroless/static-debian11:nonroot

# Copy the binary and required files
COPY --from=builder /app/main /app/main
COPY --from=builder /app/web /app/web
COPY --from=builder /app/database /app/database

# Set working directory
WORKDIR /app

# Expose port
EXPOSE 8080

# Use non-root user
USER nonroot:nonroot

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/app/main", "--health-check"] || exit 1

# Run the application
ENTRYPOINT ["/app/main"]