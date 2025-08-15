# Stanford University Students API

A RESTful API for managing Stanford University Computer Science students built with Go and Gin framework.

## Features

- ✅ CRUD operations for student management
- ✅ API versioning (v1)
- ✅ Structured logging with different log levels
- ✅ Health check endpoint
- ✅ Database migrations
- ✅ Environment-based configuration
- ✅ Unit tests
- ✅ Postman collection

## Prerequisites

Before running this application, ensure you have the following tools installed:

### Required Tools
- **Docker** (v20.10+) - [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** (v2.0+) - Usually included with Docker Desktop
- **Make** - Build automation tool
  - **Linux/macOS**: Usually pre-installed
  - **Windows**: Install via [Chocolatey](https://chocolatey.org/) or [Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm)
- **Git** - Version control

### Optional Tools (for local development)
- **Go** (v1.21+) - [Install Go](https://golang.org/doc/install)
- **PostgreSQL** (v12+) - [Install PostgreSQL](https://www.postgresql.org/download/)
- **migrate** CLI - [Install golang-migrate](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)

### Verify Installation
```bash
# Check required tools
docker --version
docker-compose --version
make --version
git --version

# Check optional tools (if doing local development)
go version
psql --version
```

## Team Onboarding

### 🎆 **For Complete Beginners**
No tools installed? No problem!

```bash
# 1. Clone the repository
git clone <repository-url>
cd stanford-uni-students-api

# 2. Run one command - it does everything!
chmod +x quick-start.sh
./quick-start.sh

# 3. Access the application
# Web: http://localhost:8080
# API: http://localhost:8080/api/v1/students
```

### 👨‍💻 **For Developers**
Have some tools but want full setup:

```bash
# 1. Install missing tools
./setup.sh

# 2. Configure environment
cp .env.example .env
# Edit .env with your database credentials

# 3. Start application
make run-api
```

### 🐳 **For Docker Users**
Only want containerized setup:

```bash
# 1. Install essential tools only
./install-tools.sh

# 2. Run with Docker
./quick-start.sh --skip-go
```

## Quick Start

### 🚀 **For New Team Members (Zero Setup)**
```bash
# Clone the repository
git clone <repository-url>
cd stanford-uni-students-api

# One-command setup and run (installs everything)
chmod +x quick-start.sh
./quick-start.sh
```

### 🛠️ **Manual Setup (If You Have Tools)**
```bash
# Clone the repository
git clone <repository-url>
cd stanford-uni-students-api

# Copy environment configuration
cp .env.example .env
# Edit .env with your credentials (see Environment Variables section)

# Start the complete application (DB + API)
make run-api
```

### 📦 **Setup Scripts for Team Members**

We provide automated setup scripts so team members don't need to install tools manually:

#### **Option 1: Complete Setup + Run**
```bash
./quick-start.sh          # Installs tools + sets up + runs app
./quick-start.sh --skip-go # Docker-only setup (no Go installation)
```

#### **Option 2: Install Tools Only**
```bash
./install-tools.sh        # Installs Docker, Make, Git only
```

#### **Option 3: Full Setup (Advanced)**
```bash
./setup.sh                # Complete setup with all options
./setup.sh --skip-go      # Skip Go installation
./setup.sh --help         # Show all options
```

### 📋 **Make Targets**

#### **Docker Operations (Recommended)**
```bash
# Start database container
make start-db

# Run database migrations
make run-migrations

# Build REST API Docker image
make build-api

# Start complete application (runs all above steps)
make run-api

# Stop all containers
make stop-all
```

#### **Development Operations**
```bash
# Run locally (requires local PostgreSQL)
make dev-local

# Run tests
make test

# Clean all artifacts
make clean

# Show all available targets
make help
```

### 🔄 **Execution Order**

The `make run-api` target automatically executes in this order:
1. **Start Database** (`start-db`) - Launches PostgreSQL container
2. **Run Migrations** (`run-migrations`) - Sets up database schema
3. **Build API** (`build-api`) - Creates Docker image
4. **Start API** - Launches the application container

### 🛠️ **Manual Step-by-Step Setup**

If you prefer to run each step manually:

```bash
# 1. Clone and setup
git clone <repository-url>
cd stanford-uni-students-api
cp .env.example .env
# Edit .env with your credentials

# 2. Start database
make start-db

# 3. Run migrations
make run-migrations

# 4. Build API image
make build-api

# 5. Start API container
docker-compose up -d app
```

## Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `POSTGRES_DB` | Database name | `stanford_students` | Yes |
| `POSTGRES_USER` | Database username | `admin_stan` | Yes |
| `POSTGRES_PASSWORD` | Database password | - | Yes |
| `DATABASE_URL` | Full connection string | Auto-generated | No |
| `PORT` | Server port | `8080` | No |
| `LOG_LEVEL` | Logging level | `info` | No |

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
docker-compose ps

# View logs
docker-compose logs app
docker-compose logs postgres

# Stop specific service
docker-compose stop app
docker-compose stop postgres

# Restart services
docker-compose restart

# Remove all containers and volumes
make clean
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
stanford-uni-students-api/
├── config/           # Configuration management
├── controllers/      # HTTP handlers
├── database/         # Database connection and migrations
├── models/          # Data models and repository
├── routes/          # Route definitions
├── tests/           # Unit tests
├── main.go          # Application entry point
├── go.mod           # Go dependencies
└── README.md        # Documentation
```