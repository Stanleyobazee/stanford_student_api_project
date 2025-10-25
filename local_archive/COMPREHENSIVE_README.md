# Stanford University Students API - Complete DevOps Journey

A production-ready REST API for managing Stanford University student records, showcasing a complete DevOps pipeline from development to deployment.

## 🎯 Project Overview

This project demonstrates a comprehensive DevOps journey through 5 key stages:
1. **REST API Development** - Building a robust CRUD API
2. **Containerization** - Docker multi-stage builds
3. **Local Development Setup** - One-click development environment
4. **CI/CD Pipeline** - Automated testing and deployment
5. **Production Deployment** - Load-balanced bare metal deployment

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Nginx LB      │    │   GitHub CI/CD  │
│   Port 8080     │    │   Self-hosted   │
└─────────┬───────┘    └─────────────────┘
          │                      │
    ┌─────▼─────┐           ┌────▼────┐
    │  App1:8081│           │ Docker  │
    └───────────┘           │ Registry│
    ┌───────────┐           └─────────┘
    │  App2:8082│
    └─────┬─────┘
          │
    ┌─────▼─────┐
    │PostgreSQL │
    │ Port 5433 │
    └───────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Make
- Git

### One-Command Setup
```bash
git clone https://github.com/Stanleyobazee/stanford_student_api_project.git
cd stanford_student_api_project
export POSTGRES_DB=stanford_students POSTGRES_USER=admin_stan POSTGRES_PASSWORD=your_password
make run-api
```

**Access Points:**
- Web Interface: http://localhost:8080
- Health Check: http://localhost:8080/healthcheck
- API Endpoints: http://localhost:8080/api/v1/students

## 📋 Stage 1: REST API Development

### Features Implemented
- ✅ Complete CRUD operations for student management
- ✅ RESTful API with proper HTTP verbs and status codes
- ✅ API versioning (`/api/v1/`)
- ✅ Structured JSON logging with Logrus
- ✅ Health check endpoint with database connectivity
- ✅ Environment-based configuration
- ✅ PostgreSQL with automated migrations
- ✅ Unit tests with coverage reporting
- ✅ Postman collection for API testing

### Technology Stack
- **Language**: Go 1.21
- **Framework**: Gin HTTP framework
- **Database**: PostgreSQL 15
- **Logging**: Logrus with JSON formatting
- **Testing**: Go testing package
- **Migration**: golang-migrate

### API Endpoints
```
GET    /healthcheck           - Health check with DB status
POST   /api/v1/students       - Create new student
GET    /api/v1/students       - Get all students
GET    /api/v1/students/:id   - Get student by ID
PUT    /api/v1/students/:id   - Update student
DELETE /api/v1/students/:id   - Delete student
```

### Student Schema
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

## 📦 Stage 2: Containerization

### Docker Implementation
- **Multi-stage Dockerfile** for optimized builds
- **Distroless final image** (~15MB) for security
- **Build stage**: golang:1.21-alpine with full toolchain
- **Runtime stage**: gcr.io/distroless/static-debian11:nonroot
- **Security**: Non-root user, minimal attack surface

### Docker Features
```dockerfile
# Build optimizations
CGO_ENABLED=0 GOOS=linux GOARCH=amd64
-ldflags='-w -s -extldflags "-static"'

# Security hardening
USER nonroot:nonroot
FROM gcr.io/distroless/static-debian11:nonroot
```

### Image Details
- **Base Image**: Distroless (Google)
- **Final Size**: ~15MB
- **Security**: CVE-free, minimal dependencies
- **Performance**: Static binary, fast startup

## 🔧 Stage 3: Local Development Setup

### One-Click Development
The Makefile provides comprehensive automation:

```bash
make run-api      # Complete setup: DB + Migrations + API + Load Balancer
make status       # Check all service status
make test         # Run unit tests with coverage
make stop-all     # Clean shutdown
```

### Development Features
- **Automated dependency management** with Go modules
- **Database migrations** with version control
- **Health monitoring** for all services
- **Hot reload** support for development
- **Comprehensive logging** with structured output
- **Environment isolation** with Docker networks

### Make Targets
```bash
# Core Operations
make start-db         # Start PostgreSQL container
make run-migrations   # Apply database migrations
make build-api        # Build Docker image
make run-api          # Full deployment

# Development
make dev-local        # Run locally (requires local PostgreSQL)
make test             # Unit tests with coverage
make lint             # Code quality checks
make fmt              # Code formatting

# Maintenance
make status           # Service health check
make stop-all         # Stop all services
make clean            # Complete cleanup
```

## 🔄 Stage 4: CI/CD Pipeline

### GitHub Actions Workflow
Comprehensive CI pipeline with self-hosted runner:

```yaml
# Trigger Conditions
- Push to main/develop branches
- Pull requests to main
- Manual workflow dispatch
- Weekly security scans
```

### Pipeline Stages
1. **Code Quality**
   - Go formatting and linting
   - Dependency vulnerability scanning
   - Code coverage reporting

2. **Testing**
   - Unit tests with race detection
   - Integration tests with real database
   - API endpoint verification

3. **Security**
   - Docker image vulnerability scanning with Trivy
   - Secrets detection
   - Dependency security audit

4. **Build & Deploy**
   - Multi-stage Docker build
   - Image optimization and caching
   - Push to Docker Hub registry
   - Automated tagging (v1, latest)

### CI Features
- **Self-hosted runner** for faster builds
- **Docker layer caching** for efficiency
- **Parallel test execution** with matrix strategy
- **Artifact management** for coverage reports
- **Resource monitoring** during builds
- **Comprehensive logging** for debugging

### Security Measures
```bash
# Trivy security scanning
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --exit-code 0 --severity HIGH,CRITICAL

# Go vulnerability check
go list -json -deps ./... | nancy sleuth
```

## 🏭 Stage 5: Production Deployment

### Vagrant Production Environment
Production-like environment using Vagrant and VirtualBox:

```ruby
# VM Configuration
config.vm.box = "ubuntu/jammy64"
config.vm.hostname = "stanford-api-prod"
vb.memory = "2048"
vb.cpus = 2
```

### Load-Balanced Architecture
- **2 API instances** (app1:8081, app2:8082)
- **Nginx load balancer** on port 8080
- **PostgreSQL database** with persistent storage
- **Health checks** for all components

### Nginx Configuration
```nginx
upstream api_backend {
    server app1:8081;
    server app2:8082;
}

server {
    listen 80;
    location / {
        proxy_pass http://api_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Production Features
- **High availability** with multiple API instances
- **Load balancing** with Nginx upstream
- **Health monitoring** for all services
- **Persistent data** with Docker volumes
- **Automated provisioning** with shell scripts
- **Resource monitoring** and logging

### Deployment Commands
```bash
# Vagrant deployment
vagrant up                    # Provision VM
vagrant ssh                   # Access production environment
cd /vagrant && make run-api   # Deploy application

# Direct deployment
make run-api                  # Start load-balanced deployment
make status                   # Monitor service health
```

## 📊 Monitoring & Observability

### Health Checks
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00Z",
  "database": "connected",
  "version": "v1.0.0"
}
```

### Logging Strategy
- **Structured JSON logging** with Logrus
- **Request/response logging** with Gin middleware
- **Database query logging** for debugging
- **Error tracking** with stack traces
- **Performance metrics** for optimization

### Monitoring Commands
```bash
# Service status
make status

# Container logs
docker compose logs app1
docker compose logs postgres
docker compose logs nginx

# Resource usage
docker stats
```

## 🧪 Testing Strategy

### Test Coverage
- **Unit tests** for all controllers and models
- **Integration tests** with test database
- **API endpoint tests** with HTTP clients
- **Health check validation**
- **Error handling verification**

### Test Execution
```bash
# Run all tests
make test

# Coverage report
go test -v -cover ./tests/...

# Race condition detection
go test -race ./tests/...
```

### Postman Collection
Comprehensive API testing collection (`stanford_students_api.postman_collection.json`) included:

**Collection Features:**
- ✅ **Health Check** - Verify API and database connectivity
- ✅ **Create Student** - POST with complete student data
- ✅ **Get All Students** - Retrieve paginated student list
- ✅ **Get Student by ID** - Fetch individual student records
- ✅ **Update Student** - PUT operations with validation
- ✅ **Delete Student** - Safe deletion with confirmation

**Import Instructions:**
```bash
# Import collection into Postman
1. Open Postman
2. Click Import
3. Select stanford_students_api.postman_collection.json
4. Set environment variable: baseUrl = http://localhost:8080
```

**Environment Variables:**
```json
{
  "baseUrl": "http://localhost:8080",
  "studentId": "1"
}
```

**Sample Requests:**
```bash
# Health Check
GET {{baseUrl}}/healthcheck

# Create Student
POST {{baseUrl}}/api/v1/students
Content-Type: application/json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@stanford.edu",
  "student_id": "CS001",
  "major": "Computer Science",
  "year": 3
}

# Get All Students
GET {{baseUrl}}/api/v1/students

# Update Student
PUT {{baseUrl}}/api/v1/students/1
```

## 🔒 Security Implementation

### Security Measures
- **Distroless container images** for minimal attack surface
- **Non-root user execution** in containers
- **Environment variable management** for secrets
- **SQL injection prevention** with parameterized queries
- **Input validation** and sanitization
- **CORS configuration** for web security

### Security Scanning
```bash
# Container vulnerability scanning
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image stanford-students-api:v1

# Dependency scanning
go list -json -deps ./... | nancy sleuth
```

## 📈 Performance Optimization

### Optimization Techniques
- **Multi-stage Docker builds** for smaller images
- **Connection pooling** for database efficiency
- **Gin middleware optimization** for faster routing
- **Static binary compilation** for faster startup
- **Docker layer caching** for build speed

### Performance Metrics
- **Image size**: ~15MB (distroless)
- **Startup time**: <2 seconds
- **Memory usage**: ~20MB per instance
- **Response time**: <100ms for CRUD operations

## 🛠️ Development Workflow

### Local Development
```bash
# Setup development environment
git clone <repository>
cd stanford_student_api_project
cp .env.example .env
# Edit .env with your database credentials

# Start development
make run-api
make test
```

### Code Quality
```bash
# Format code
make fmt

# Run linter
make lint

# Run tests with coverage
make test
```

### Debugging
```bash
# View logs
docker compose logs app1 --follow

# Database access
docker compose exec postgres psql -U admin_stan -d stanford_students

# Container shell access
docker compose exec app1 sh
```

## 📚 Documentation

### API Documentation
- **Postman Collection** (`stanford_students_api.postman_collection.json`) - Complete API testing suite
- **cURL examples** for all endpoints with response samples
- **Response schemas** and comprehensive error codes
- **Environment setup** for different deployment targets (local, staging, production)

**Postman Collection Highlights:**
- Pre-configured requests for all endpoints
- Environment variables for easy switching between environments
- Sample request bodies with realistic Stanford student data
- Response validation and testing scripts
- Ready-to-use collection for API exploration and testing

### Deployment Documentation
- **Environment setup** instructions
- **Configuration management** guide
- **Troubleshooting** common issues
- **Monitoring** and maintenance procedures

## 🔧 Troubleshooting

### Common Issues

#### Port Conflicts
```bash
# Check port usage
lsof -i :8080

# Kill conflicting process
kill -9 <PID>
```

#### Database Connection
```bash
# Restart database
make start-db

# Check database logs
docker compose logs postgres
```

#### Migration Issues
```bash
# Reset migrations
rm -f .migrations_applied
make run-migrations
```

#### Docker Issues
```bash
# Clean Docker cache
docker system prune -a

# Rebuild images
make build-api
```

## 📋 Project Structure

```
stanford_student_api_project/
├── .github/workflows/          # CI/CD pipeline
│   └── ci.yml                 # GitHub Actions workflow
├── config/                    # Configuration management
│   └── config.go             # Environment configuration
├── controllers/               # HTTP request handlers
│   ├── health_controller.go  # Health check endpoint
│   └── student_controller.go # Student CRUD operations
├── database/                  # Database layer
│   ├── migrations/           # SQL migration files
│   │   ├── 001_create_students_table.up.sql
│   │   └── 001_create_students_table.down.sql
│   └── database.go          # Database connection and setup
├── models/                   # Data models and repository
│   └── student.go           # Student model and repository
├── nginx/                    # Load balancer configuration
│   └── nginx.conf           # Nginx upstream configuration
├── routes/                   # API route definitions
│   └── routes.go            # Route setup and middleware
├── scripts/                  # Deployment scripts
│   └── setup-production.sh  # Vagrant provisioning script
├── tests/                    # Unit and integration tests
│   ├── health_controller_test.go
│   └── student_controller_test.go
├── web/                      # Frontend web interface
│   ├── index.html           # Main web page
│   └── app.js               # Frontend JavaScript
├── main.go                   # Application entry point
├── go.mod                    # Go module dependencies
├── go.sum                    # Dependency checksums
├── Dockerfile                # Multi-stage container build
├── docker-compose.yml        # Container orchestration
├── Vagrantfile              # Production VM configuration
├── Makefile                 # Build automation
├── .env.example             # Environment template
├── .gitignore               # Git ignore patterns
└── stanford_students_api.postman_collection.json
```

## 🎯 Learning Outcomes Achieved

### Technical Skills
- **REST API Design** with proper HTTP semantics
- **Go Programming** with modern practices
- **Docker Containerization** with security best practices
- **CI/CD Pipeline** implementation with GitHub Actions
- **Load Balancing** with Nginx
- **Database Management** with PostgreSQL and migrations
- **Infrastructure as Code** with Vagrant and shell scripts

### DevOps Practices
- **Twelve-Factor App** methodology implementation
- **Automated Testing** with comprehensive coverage
- **Security Scanning** and vulnerability management
- **Monitoring and Logging** for production systems
- **Environment Management** and configuration
- **Deployment Automation** and rollback strategies

## 🏆 Project Highlights

### Production-Ready Features
- ✅ **High Availability**: Load-balanced with 2 API instances
- ✅ **Security**: Distroless images, non-root execution
- ✅ **Monitoring**: Health checks and structured logging
- ✅ **Automation**: One-command deployment and testing
- ✅ **Scalability**: Horizontal scaling with Docker Compose
- ✅ **Maintainability**: Comprehensive documentation and tests

### Best Practices Implemented
- ✅ **Clean Architecture**: Separation of concerns
- ✅ **Error Handling**: Comprehensive error management
- ✅ **Code Quality**: Linting, formatting, and testing
- ✅ **Security**: Input validation and SQL injection prevention
- ✅ **Performance**: Optimized builds and efficient routing
- ✅ **Documentation**: Complete API and deployment docs

## 🚀 Future Enhancements

### Potential Improvements
- **Kubernetes deployment** for cloud-native scaling
- **Prometheus monitoring** with Grafana dashboards
- **JWT authentication** and authorization
- **Rate limiting** and API throttling
- **Caching layer** with Redis
- **Message queuing** with RabbitMQ or Kafka
- **Microservices architecture** decomposition
- **GraphQL API** alongside REST endpoints

### Scaling Considerations
- **Database sharding** for large datasets
- **CDN integration** for static assets
- **Multi-region deployment** for global availability
- **Auto-scaling** based on metrics
- **Circuit breakers** for fault tolerance
- **Blue-green deployment** for zero-downtime updates

## 📞 Support & Contributing

### Getting Help
- Check the troubleshooting section
- Review the comprehensive documentation
- Examine the test cases for usage examples
- Create an issue in the GitHub repository

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Run the full test suite
5. Submit a pull request

### Code Standards
- Follow Go formatting conventions
- Write comprehensive tests
- Update documentation
- Use conventional commit messages

---

## 🎉 Conclusion

This Stanford Students API project demonstrates a complete DevOps journey from initial development to production deployment. It showcases modern development practices, comprehensive testing, security considerations, and production-ready deployment strategies.

The project serves as a practical example of building scalable, maintainable, and secure web applications using Go, Docker, and modern DevOps practices.

**🌟 Star this repository if you found it helpful!**

---

*Built with ❤️ by Stanley Obazee - Demonstrating modern DevOps practices and Go development*