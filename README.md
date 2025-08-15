# Stanford University Students API

A RESTful API for managing Stanford University Computer Science students built with Go and Gin framework.

## Features

- ✅ CRUD operations for student management
- ✅ API versioning (v1)
- ✅ Structured logging with different log levels
- ✅ Health check endpoint
- ✅ Database migrations
- ✅ Environment-based configuration
- ✅ Docker containerization with multi-stage builds
- ✅ Production-ready Makefile automation
- ✅ Web interface for student management
- ✅ Unit tests
- ✅ Postman collection

## Prerequisites

### Required Tools
- **Docker** (v20.10+) - [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** (v2.0+) - Uses `docker compose` syntax (newer versions)
- **Make** - Build automation tool
  - **Linux/Ubuntu**: `sudo apt install make`
  - **macOS**: Usually pre-installed
  - **Windows**: Install via [Chocolatey](https://chocolatey.org/)
- **Git** - Version control

### Optional Tools (for local development)
- **Go** (v1.21+) - [Install Go](https://golang.org/doc/install)
- **PostgreSQL** (v12+) - [Install PostgreSQL](https://www.postgresql.org/download/)
- **migrate** CLI - [Install golang-migrate](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)

### Verify Installation
```bash
# Check required tools
docker --version
docker compose version
make --version
git --version

# Check optional tools (if doing local development)
go version
psql --version
```

## Quick Start

### 🚀 **Recommended: Simple 3-Step Setup**
```bash
# 1. Clone the repository
git clone https://github.com/Stanleyobazee/stanford_student_api_project.git
cd stanford_student_api_project

# 2. Set environment variables
export POSTGRES_DB=stanford_students
export POSTGRES_USER=admin_stan
export POSTGRES_PASSWORD=admin12345

# 3. Start the application
make run-api
```

### 🌐 **Access Your Application**
- **Web Interface**: http://localhost:8080
- **Health Check**: http://localhost:8080/healthcheck
- **API Endpoints**: http://localhost:8080/api/v1/students

## Team Onboarding

### 🎯 **Production Ready Setup**

```bash
# 1. Clone the repository
git clone https://github.com/Stanleyobazee/stanford_student_api_project.git
cd stanford_student_api_project

# 2. Set environment variables
export POSTGRES_DB=stanford_students
export POSTGRES_USER=admin_stan
export POSTGRES_PASSWORD=admin12345

# 3. Start the application
make run-api

# 4. Verify it's running
make status
```

### 🔧 **Development Workflow**

```bash
# Start application
make run-api

# Check status anytime
make status

# View logs
docker compose logs app

# Stop when done
make stop-all
```

### 🚀 **For Complete Beginners**
If you don't have Docker/Make installed:

```bash
# Install tools first (Ubuntu/Linux)
sudo apt update
sudo apt install docker.io make git

# Then follow the production setup above
```

### 📦 **Automated Setup Scripts**

For team members who need tool installation:

```bash
# Complete setup and run
chmod +x quick-start.sh
./quick-start.sh

# Install tools only
chmod +x install-tools.sh
./install-tools.sh

# Advanced setup with options
chmod +x setup.sh
./setup.sh --help
```

### 📋 **Make Commands**

#### **Essential Commands**
```bash
# Start the complete application
make run-api

# Check application status
make status

# Stop all containers
make stop-all
```

#### **Individual Operations**
```bash
# Start database only
make start-db

# Run database migrations
make run-migrations

# Build API Docker image
make build-api
```

#### **Development & Maintenance**
```bash
# Run tests
make test

# Clean all artifacts
make clean

# Show all available targets
make help
```

### 🔄 **Execution Order**

The `make run-api` target automatically executes in this order:
1. **Build API** (`build-api`) - Creates Docker image (skips if exists)
2. **Start Database** (`start-db`) - Launches PostgreSQL container
3. **Run Migrations** (`run-migrations`) - Sets up database schema
4. **Start API** - Launches the application container

### 🛠️ **Manual Step-by-Step Setup**

If you prefer to run each step manually:

```bash
# 1. Clone and setup
git clone https://github.com/Stanleyobazee/stanford_student_api_project.git
cd stanford_student_api_project

# 2. Set environment variables
export POSTGRES_DB=stanford_students
export POSTGRES_USER=admin_stan
export POSTGRES_PASSWORD=admin12345

# 3. Build API image
make build-api

# 4. Start database
make start-db

# 5. Run migrations
make run-migrations

# 6. Start API container
docker compose up -d app
```

## Environment Variables

**Required environment variables (export before running):**

```bash
export POSTGRES_DB=stanford_students
export POSTGRES_USER=admin_stan
export POSTGRES_PASSWORD=admin12345
```

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `POSTGRES_DB` | Database name | `stanford_students` | Yes |
| `POSTGRES_USER` | Database username | `admin_stan` | Yes |
| `POSTGRES_PASSWORD` | Database password | `admin12345` | Yes |
| `DATABASE_URL` | Full connection string | Auto-generated | No |
| `PORT` | Server port | `8080` | No |
| `LOG_LEVEL` | Logging level | `info` | No |

**Note**: The `.env` file is also supported, but exporting variables is the recommended approach.

## API Endpoints

### Health Check
- `GET /healthcheck` - Check API and database health

### Students (v1)
- `POST /api/v1/students` - Create a new student
- `GET /api/v1/students` - Get all students
- `GET /api/v1/students/:id` - Get student by ID
- `PUT /api/v1/students/:id` - Update student
- `DELETE /api/v1/students/:id` - Delete student

## Student Schema

```json
{
  "id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@stanford.edu",
  "student_id": "CS001",
  "major": "Computer Science",
  "year": 3,
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

## Docker Usage

### Container Access
- **Web Interface**: http://localhost:8080
- **API Health Check**: http://localhost:8080/healthcheck
- **Database**: localhost:5433 (containerized) or localhost:5432 (local)

### Container Management
```bash
# View running containers
docker compose ps

# View logs
docker compose logs app
docker compose logs postgres

# Stop specific service
docker compose stop app
docker compose stop postgres

# Restart services
docker compose restart

# Check application status
make status

# Stop all containers
make stop-all
```

### Data Persistence
- Database data is stored in `./postgres_data/` directory
- Data survives container restarts and rebuilds
- To reset database: `rm -rf postgres_data/` and `make run-api`

## Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
go test -v -cover ./tests/...

# Run specific test
go test -v ./tests/ -run TestCreateStudent
```

## Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Check what's using port 8080
lsof -i :8080
# Kill the process or use different port
```

**Database connection failed:**
```bash
# Check if database is running
make start-db
# Verify credentials in .env file
```

**Migrations failed:**
```bash
# Reset migrations
rm -f .migrations_applied
make run-migrations
```

**Docker build failed:**
```bash
# Clean Docker cache
docker system prune -a
make build-api
```

## Database Migrations

Migrations run automatically on application startup. To run manually:

```bash
# Up migrations
migrate -path database/migrations -database "postgres://user:password@localhost:5432/stanford_students?sslmode=disable" up

# Down migrations
migrate -path database/migrations -database "postgres://user:password@localhost:5432/stanford_students?sslmode=disable" down
```

## Postman Collection

Import `stanford_students_api.postman_collection.json` into Postman to test all endpoints.

## Project Structure

```
stanford_student_api_project/
├── config/                    # Configuration management
├── controllers/               # HTTP handlers
├── database/                  # Database connection and migrations
│   └── migrations/           # SQL migration files
├── models/                   # Data models and repository
├── routes/                   # Route definitions
├── tests/                    # Unit tests
├── web/                      # Frontend web interface
│   ├── index.html           # Main web page
│   └── app.js               # Frontend JavaScript
├── main.go                   # Application entry point
├── go.mod                    # Go dependencies
├── Dockerfile                # Multi-stage Docker build
├── docker-compose.yml        # Container orchestration
├── Makefile                  # Build automation
├── .env.example              # Environment template
└── README.md                 # Documentation
```

## Docker Images

- **API Image**: `stanford-students-api:v1` (~15MB distroless)
- **Database**: `postgres:15-alpine`
- **Multi-stage build** for optimized production image

## Production Features

- ✅ **Distroless final image** for security
- ✅ **Health checks** for containers
- ✅ **Volume persistence** for database
- ✅ **Environment-based configuration**
- ✅ **Automated migrations**
- ✅ **Smart build caching** (skips rebuild if image exists)
- ✅ **Container status monitoring**