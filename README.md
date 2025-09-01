# Stanford University Students API

🚀 **A production-ready REST API showcasing a complete DevOps journey from development to deployment**

Built with Go, PostgreSQL, Docker, and modern DevOps practices - this project demonstrates the full lifecycle of building, testing, containerizing, and deploying a scalable web application.

## 🎯 Project Highlights

- **Complete DevOps Pipeline**: 5-stage journey from API development to production deployment
- **Production-Ready Architecture**: Load-balanced deployment with high availability
- **Security-First Approach**: Distroless containers, vulnerability scanning, secure practices
- **Comprehensive Testing**: Unit tests, integration tests, and automated CI/CD
- **Modern Tech Stack**: Go 1.21, PostgreSQL, Docker, Nginx, GitHub Actions

## Features
- ✅ Complete CRUD operations for student management
- ✅ RESTful API with JSON responses
- ✅ PostgreSQL database with automated migrations
- ✅ Docker containerization with multi-stage builds
- ✅ Production-ready Makefile automation
- ✅ Web interface for student management
- ✅ Health check endpoint
- ✅ Unit tests and Postman collection
- ✅ Environment-based configuration

## Prerequisites

### Required Tools
- **Docker** (v20.10+) - [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** (v2.0+)
- **Make** - Build automation
- **Git** - Version control

### Verify Installation
Run these commands to verify your tools are installed:

```bash
docker --version
```

```bash
docker compose version
```

```bash
make --version
```

```bash
git --version
```

*📸 Screenshot: Add screenshot showing successful version checks*

## Quick Start (3 Steps)

### Step 1: Clone Repository
```bash
git clone https://github.com/Stanleyobazee/stanford_student_api_project.git
```

```bash
cd stanford_student_api_project
```

*📸 Screenshot: Add screenshot of successful clone and directory change*

### Step 2: Set Environment Variables
```bash
export POSTGRES_DB=your_database_name
```

```bash
export POSTGRES_USER=your_username
```

```bash
export POSTGRES_PASSWORD=your_password
```

*📸 Screenshot: Add screenshot showing environment variables being set*

### Step 3: Start Application
```bash
make run-api
```

*📸 Screenshot: Add screenshot of successful application startup*

### Verify Application is Running
```bash
make status
```

*📸 Screenshot: Add screenshot showing running containers*

## Access Your Application

- **Web Interface**: http://localhost:8080
- **Health Check**: http://localhost:8080/healthcheck  
- **API Base**: http://localhost:8080/api/v1/students

*📸 Screenshot: Add screenshot of web interface*
*📸 Screenshot: Add screenshot of health check response*

## Essential Commands

### Start Application
```bash
make run-api
```

### Check Status
```bash
make status
```

### View Application Logs
```bash
docker compose logs app
```

### View Database Logs
```bash
docker compose logs postgres
```

### Stop All Services
```bash
make stop-all
```

*📸 Screenshot: Add screenshot showing logs output*

## Individual Service Management

### Start Database Only
```bash
make start-db
```

### Run Database Migrations
```bash
make run-migrations
```

### Build API Image
```bash
make build-api
```

### View Running Containers
```bash
docker compose ps
```

*📸 Screenshot: Add screenshot of docker compose ps output*

## Testing the API

### Health Check
```bash
curl http://localhost:8080/healthcheck
```

### Create a Student
```bash
curl -X POST http://localhost:8080/api/v1/students \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "John",
    "last_name": "Doe",
    "email": "john.doe@stanford.edu",
    "student_id": "CS001",
    "major": "Computer Science",
    "year": 3
  }'
```

### Get All Students
```bash
curl http://localhost:8080/api/v1/students
```

### Get Student by ID
```bash
curl http://localhost:8080/api/v1/students/1
```

*📸 Screenshot: Add screenshot of API responses*

## Running Tests

### Run All Tests
```bash
make test
```

### Run Tests with Coverage
```bash
go test -v -cover ./tests/...
```

### Run Specific Test
```bash
go test -v ./tests/ -run TestCreateStudent
```

*📸 Screenshot: Add screenshot of test results*

## Environment Configuration

### Required Variables
These must be set before running the application:

```bash
export POSTGRES_DB=your_database_name
export POSTGRES_USER=your_username
export POSTGRES_PASSWORD=your_password
```

### Optional Variables
```bash
export PORT=8080
export LOG_LEVEL=info
```

### Environment Variables Reference
| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `POSTGRES_DB` | Database name | `your_database_name` | Yes |
| `POSTGRES_USER` | Database username | `your_username` | Yes |
| `POSTGRES_PASSWORD` | Database password | `your_password` | Yes |
| `DATABASE_URL` | Full connection string | Auto-generated | No |
| `PORT` | Server port | `8080` | No |
| `LOG_LEVEL` | Logging level | `info` | No |

## API Reference

### Health Check
```
GET /healthcheck
```
Check API and database connectivity

### Student Endpoints
```
POST /api/v1/students
```
Create a new student

```
GET /api/v1/students
```
Retrieve all students

```
GET /api/v1/students/:id
```
Retrieve student by ID

```
PUT /api/v1/students/:id
```
Update existing student

```
DELETE /api/v1/students/:id
```
Delete student by ID

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

## Container Management

### View Container Status
```bash
docker compose ps
```

### View Application Logs
```bash
docker compose logs app
```

### View Database Logs
```bash
docker compose logs postgres
```

### Stop Specific Service
```bash
docker compose stop app
```

```bash
docker compose stop postgres
```

### Restart All Services
```bash
docker compose restart
```

### Remove All Containers
```bash
docker compose down
```

*📸 Screenshot: Add screenshot of container management commands*

## Data Management

### Database Data Location
Database data persists in: `./postgres_data/`

### Reset Database
```bash
rm -rf postgres_data/
```

```bash
make run-api
```

### Backup Database
```bash
docker compose exec postgres pg_dump -U $POSTGRES_USER $POSTGRES_DB > backup.sql
```

### Restore Database
```bash
docker compose exec -T postgres psql -U $POSTGRES_USER $POSTGRES_DB < backup.sql
```



## Troubleshooting

### Port Already in Use
Check what's using port 8080:
```bash
lsof -i :8080
```

Kill the process:
```bash
kill -9 <PID>
```

### Database Connection Issues
Restart database:
```bash
make start-db
```

Check database status:
```bash
docker compose logs postgres
```

### Migration Problems
Reset migrations:
```bash
rm -f .migrations_applied
```

```bash
make run-migrations
```

### Docker Build Issues
Clean Docker cache:
```bash
docker system prune -a
```

Rebuild API:
```bash
make build-api
```

### View All Make Targets
```bash
make help
```

*📸 Screenshot: Add screenshot of troubleshooting commands output*

## Database Migrations

Migrations run automatically on startup. For manual control:

### Run Migrations Up
```bash
migrate -path database/migrations -database "postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB?sslmode=disable" up
```

### Run Migrations Down
```bash
migrate -path database/migrations -database "postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB?sslmode=disable" down
```

### Check Migration Status
```bash
migrate -path database/migrations -database "postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB?sslmode=disable" version
```

## API Testing

### Option 1: Postman Collection (Recommended)
**Complete API testing suite included:**
```
File: stanford_students_api.postman_collection.json
```

**Collection Features:**
- ✅ **Health Check** - Verify API and database connectivity
- ✅ **Create Student** - POST with sample Stanford student data
- ✅ **Get All Students** - Retrieve complete student list
- ✅ **Get Student by ID** - Fetch individual records
- ✅ **Update Student** - PUT operations with validation
- ✅ **Delete Student** - Safe deletion operations

**Quick Setup:**
1. Import `stanford_students_api.postman_collection.json` into Postman
2. Set environment variable: `baseUrl = http://localhost:8080`
3. Run requests in sequence to test full CRUD workflow

**Sample Request Body (included in collection):**
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@stanford.edu",
  "student_id": "CS001",
  "major": "Computer Science",
  "year": 3
}
```

### Option 2: cURL Examples
See the "Testing the API" section above for curl commands.

*📸 Screenshot: Add screenshot of Postman collection interface*
*📸 Screenshot: Add screenshot of successful API responses*

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

- ✅ **Distroless final image** (~15MB) for security
- ✅ **Health checks** for all containers
- ✅ **Volume persistence** for database
- ✅ **Environment-based configuration**
- ✅ **Automated database migrations**
- ✅ **Smart build caching**
- ✅ **Container status monitoring**
- ✅ **Multi-stage Docker builds**

## Quick Reference

### Most Used Commands
```bash
make run-api     # Start everything
make status      # Check status
make stop-all    # Stop everything
make test        # Run tests
```

### Access Points
- Web UI: http://localhost:8080
- Health: http://localhost:8080/healthcheck
- API: http://localhost:8080/api/v1/students

### Support
For issues or questions, check the troubleshooting section or create an issue in the repository.

*📸 Screenshot: Add final screenshot showing the complete running application*

---
# 
**🎉 Congratulations! Your Stanford Students API CI pipeline is now working successfully.**