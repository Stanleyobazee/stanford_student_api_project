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

- Go 1.21+
- PostgreSQL 12+
- Git

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd stanford-uni-students-api
   ```

2. **Install dependencies**
   ```bash
   go mod tidy
   ```

3. **Setup PostgreSQL database**
   ```sql
   CREATE DATABASE stanford_students;
   CREATE USER your_user WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE stanford_students TO your_user;
   ```

4. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

5. **Run the application**
   ```bash
   go run main.go
   ```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgres://user:password@localhost:5432/stanford_students?sslmode=disable` |
| `PORT` | Server port | `8080` |
| `LOG_LEVEL` | Logging level (debug, info, warn, error) | `info` |

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

## Running Tests

```bash
go test ./tests/...
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