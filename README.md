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

## Kubernetes Deployment (Stage 7)

### Prerequisites

- **Kubernetes Cluster**: 4-node Minikube cluster running
- **kubectl**: Configured to connect to your cluster
- **Docker Images**: Available in Docker Hub (stanley80/stanford-students-api)

### Kubernetes Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        Stanford Students API - Kubernetes Cluster               │
│                                  (4-Node Setup)                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  🎛️  CONTROL PLANE NODE                                                        │
│  stanford-students-cluster                                                      │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                  │
│  │   API Server    │ │    Scheduler    │ │      etcd       │                  │
│  │   (Port 8443)   │ │   (Pod Mgmt)    │ │  (Cluster DB)   │                  │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘                  │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ kubectl commands
                                      │
┌─────────────────────────────────────┼─────────────────────────────────────────┐
│                                     │                                         │
│  🚀 APPLICATION NODE                │  🗄️  DATABASE NODE                     │
│  stanford-students-cluster-m02      │  stanford-students-cluster-m03          │
│  (type=application)                 │  (type=database)                        │
│                                     │                                         │
│  ┌─────────────────────────────────┐│  ┌─────────────────────────────────────┐│
│  │        student-api namespace    ││  │        student-api namespace        ││
│  │                                 ││  │                                     ││
│  │  ┌─────────────────────────────┐││  │  ┌─────────────────────────────────┐││
│  │  │     API Pod (Replica 1)     │││  │  │       PostgreSQL Pod            │││
│  │  │  ┌─────────────────────────┐│││  │  │  ┌─────────────────────────────┐│││
│  │  │  │    Init Container       ││││  │  │  │      postgres:15-alpine    ││││
│  │  │  │   (DB Migrations)       ││││  │  │  │       Port: 5432            ││││
│  │  │  └─────────────────────────┘│││  │  │  │                             ││││
│  │  │  ┌─────────────────────────┐│││  │  │  │  ConfigMap:                 ││││
│  │  │  │   Main Container        ││││  │  │  │  - POSTGRES_DB              ││││
│  │  │  │ stanford-students-api   ││││  │  │  │  - POSTGRES_USER            ││││
│  │  │  │    Port: 8080           ││││  │  │  │                             ││││
│  │  │  └─────────────────────────┘│││  │  │  │  Secret:                    ││││
│  │  └─────────────────────────────┘││  │  │  │  - POSTGRES_PASSWORD        ││││
│  │                                 ││  │  │  └─────────────────────────────┘││
│  │  ┌─────────────────────────────┐││  │  └─────────────────────────────────┘│
│  │  │     API Pod (Replica 2)     │││  │                                     │
│  │  │   (Same as Replica 1)       │││  │  ┌─────────────────────────────────┐│
│  │  └─────────────────────────────┘││  │  │    Persistent Volume Claim      ││
│  │                                 ││  │  │         (5Gi Storage)           ││
│  │  ┌─────────────────────────────┐││  │  │    /var/lib/postgresql/data     ││
│  │  │      NodePort Service       │││  │  └─────────────────────────────────┘│
│  │  │        Port: 30080          │││  │                                     │
│  │  │    (External Access)        │││  │  ┌─────────────────────────────────┐│
│  │  └─────────────────────────────┘││  │  │      ClusterIP Service          ││
│  └─────────────────────────────────┘│  │  │   postgres-service:5432         ││
└─────────────────────────────────────┘  │  │     (Internal Access)           ││
                                          │  └─────────────────────────────────┘│
                                          └─────────────────────────────────────┘
                                                              │
                                                              │ Internal DB Connection
                                                              │ postgres://postgres:***@postgres-service:5432/stanford_students
┌─────────────────────────────────────────────────────────────┼─────────────────────┐
│  🔧 DEPENDENT SERVICES NODE                                  │                     │
│  stanford-students-cluster-m04                              │                     │
│  (type=dependent_services)                                  │                     │
│                                                             │                     │
│  ┌─────────────────────────────────────────────────────────┼─────────────────────┐│
│  │                    vault namespace                       │                     ││
│  │                                                          │                     ││
│  │  ┌─────────────────────────────────────────────────────┐│                     ││
│  │  │                HashiCorp Vault Pod                  ││                     ││
│  │  │  ┌─────────────────────────────────────────────────┐││                     ││
│  │  │  │              vault:1.15.2                       │││                     ││
│  │  │  │             Port: 8200                          │││                     ││
│  │  │  │                                                 │││                     ││
│  │  │  │  Secret Storage:                                │││                     ││
│  │  │  │  - Database credentials                         │││                     ││
│  │  │  │  - API keys                                     │││                     ││
│  │  │  │  - TLS certificates                             │││                     ││
│  │  │  └─────────────────────────────────────────────────┘││                     ││
│  │  └─────────────────────────────────────────────────────┘│                     ││
│  │                                                          │                     ││
│  │  ┌─────────────────────────────────────────────────────┐│                     ││
│  │  │              ClusterIP Service                       ││                     ││
│  │  │         vault-service:8200                           ││                     ││
│  │  └─────────────────────────────────────────────────────┘│                     ││
│  └──────────────────────────────────────────────────────────┘                     ││
│                                                                                   ││
│  ┌─────────────────────────────────────────────────────────────────────────────┐ ││
│  │                    external-secrets namespace                                │ ││
│  │                                                                             │ ││
│  │  ┌─────────────────────────────────────────────────────────────────────────┐│ ││
│  │  │              External Secrets Operator (ESO)                           ││ ││
│  │  │                                                                         ││ ││
│  │  │  • Watches for ExternalSecret resources                                 ││ ││
│  │  │  • Fetches secrets from Vault                                           ││ ││
│  │  │  • Creates Kubernetes secrets automatically                             ││ ││
│  │  │  • Syncs secret changes from Vault to K8s                              ││ ││
│  │  └─────────────────────────────────────────────────────────────────────────┘│ ││
│  └─────────────────────────────────────────────────────────────────────────────┘ ││
└───────────────────────────────────────────────────────────────────────────────────┘│
                                                                                    │
┌───────────────────────────────────────────────────────────────────────────────────┘
│  🌐 EXTERNAL ACCESS FLOW
│
│  Internet/User
│       │
│       │ HTTP Requests
│       │ Port: 30080
│       ▼
│  ┌─────────────────┐
│  │   Minikube IP   │ ──────────────────────────────────────────────────────────┐
│  │ (External LB)   │                                                           │
│       │                                                                        │
│       │ Routes to                                                              │
│       ▼                                                                        │
│  ┌─────────────────┐                                                          │
│  │  NodePort Svc   │ ──────────────────────────────────────────────────────┐ │
│  │   Port: 30080   │                                                        │ │
│       │                                                                     │ │
│       │ Load Balances                                                       │ │
│       ▼                                                                     │ │
│  ┌─────────────────┐    ┌─────────────────┐                               │ │
│  │   API Pod 1     │    │   API Pod 2     │                               │ │
│  │  Port: 8080     │    │  Port: 8080     │                               │ │
│  └─────────────────┘    └─────────────────┘                               │ │
│                                                                            │ │
└────────────────────────────────────────────────────────────────────────────┘ │
                                                                               │
┌──────────────────────────────────────────────────────────────────────────────┘
│  🔐 SECURITY & SECRETS FLOW
│
│  1. Vault stores sensitive data (DB passwords, API keys)
│  2. External Secrets Operator fetches from Vault
│  3. ESO creates Kubernetes secrets automatically
│  4. Pods consume secrets as environment variables
│  5. No hardcoded credentials in manifests or images
│
└─────────────────────────────────────────────────────────────────────────────────
```

### Cluster Architecture Summary

```
📦 Kubernetes Cluster (4 nodes)
├── 🎛️ Control Plane: stanford-students-cluster
├── 🚀 Application Node: stanford-students-cluster-m02 (type=application)
├── 🗄️ Database Node: stanford-students-cluster-m03 (type=database)
└── 🔧 Services Node: stanford-students-cluster-m04 (type=dependent_services)
```

### Kubernetes Components

```
📁 k8s/
├── 📁 manifests/
│   ├── namespace.yml          # Isolated environments
│   ├── database.yml           # PostgreSQL with persistent storage
│   ├── application.yml        # API with init containers
│   ├── vault.yml              # HashiCorp Vault for secrets
│   └── external-secrets.yml   # External Secrets Operator
├── 📁 vault/
│   └── setup-vault.sh         # Vault initialization
└── deploy.sh                  # Complete deployment script
```

### Step-by-Step Deployment

#### Step 1: Verify Cluster Status
```bash
kubectl get nodes
```

*Expected output: 4 nodes (1 control-plane + 3 workers) in Ready status*

#### Step 2: Deploy Namespaces
```bash
kubectl apply -f k8s/manifests/namespace.yml
```

**What this creates:**
- `student-api` namespace (application and database)
- `vault` namespace (secret management)
- `external-secrets` namespace (ESO components)

#### Step 3: Deploy Database
```bash
kubectl apply -f k8s/manifests/database.yml
```

**Components deployed:**
- PostgreSQL deployment on database node
- Persistent Volume Claim (5Gi storage)
- ConfigMap for database configuration
- ClusterIP service for internal access

#### Step 4: Create Database Secret (Temporary)
```bash
kubectl create secret generic postgres-secret \
  --from-literal=password=your_secure_password_123 \
  -n student-api
```

#### Step 5: Deploy Application
```bash
kubectl apply -f k8s/manifests/application.yml
```

**Components deployed:**
- API deployment with 2 replicas on application node
- Init container for database migrations
- ConfigMap for application configuration
- NodePort service (port 30080) for external access

### Verification Commands

#### Check All Pods
```bash
kubectl get pods -n student-api
```

#### Check Services
```bash
kubectl get services -n student-api
```

#### View Pod Logs
```bash
# Application logs
kubectl logs -f deployment/stanford-students-api -n student-api

# Database logs
kubectl logs -f deployment/postgres -n student-api
```

#### Check Pod Distribution Across Nodes
```bash
kubectl get pods -n student-api -o wide
```

*Verify pods are scheduled on correct node types*

### Access Your Kubernetes Application

#### Get Minikube IP
```bash
minikube ip --profile stanford-students-cluster
```

#### Access Points
- **API Base**: `http://<minikube-ip>:30080/api/v1/students`
- **Health Check**: `http://<minikube-ip>:30080/healthcheck`
- **Web Interface**: `http://<minikube-ip>:30080`

#### Test API Endpoints
```bash
# Health check
curl http://<minikube-ip>:30080/healthcheck

# Create student
curl -X POST http://<minikube-ip>:30080/api/v1/students \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "John",
    "last_name": "Doe",
    "email": "john.doe@stanford.edu",
    "student_id": "K8S001",
    "major": "Computer Science",
    "year": 3
  }'

# Get all students
curl http://<minikube-ip>:30080/api/v1/students
```

### Advanced Features (Future Stages)

#### HashiCorp Vault Integration
```bash
# Deploy Vault (Stage 7 advanced)
kubectl apply -f k8s/manifests/vault.yml

# Setup Vault secrets
chmod +x k8s/vault/setup-vault.sh
./k8s/vault/setup-vault.sh
```

#### External Secrets Operator
```bash
# Deploy ESO configuration
kubectl apply -f k8s/manifests/external-secrets.yml
```

### Kubernetes Troubleshooting

#### Pod Not Starting
```bash
# Describe pod for events
kubectl describe pod <pod-name> -n student-api

# Check pod logs
kubectl logs <pod-name> -n student-api
```

#### Service Not Accessible
```bash
# Check service endpoints
kubectl get endpoints -n student-api

# Port forward for testing
kubectl port-forward service/stanford-students-api-service 8080:80 -n student-api
```

#### Database Connection Issues
```bash
# Test database connectivity
kubectl exec -it deployment/postgres -n student-api -- psql -U postgres -d stanford_students -c "\l"
```

#### Node Affinity Issues
```bash
# Check node labels
kubectl get nodes --show-labels

# Check pod placement
kubectl get pods -n student-api -o wide
```

### Cleanup Commands

#### Remove Application
```bash
kubectl delete -f k8s/manifests/application.yml
```

#### Remove Database (⚠️ Data Loss)
```bash
kubectl delete -f k8s/manifests/database.yml
```

#### Remove All Resources
```bash
kubectl delete namespace student-api
```

### Production Considerations

- ✅ **Node Affinity**: Pods scheduled on appropriate node types
- ✅ **Resource Limits**: CPU and memory constraints defined
- ✅ **Health Checks**: Liveness and readiness probes configured
- ✅ **Persistent Storage**: Database data survives pod restarts
- ✅ **Init Containers**: Database migrations run before app starts
- ✅ **ConfigMaps**: Environment-specific configuration
- 🔄 **Secrets Management**: Vault integration (advanced setup)
- 🔄 **External Secrets**: ESO for secure credential injection

---

## Helm Deployment (Stage 8)

### Prerequisites

- **Helm 3.x**: Package manager for Kubernetes - [Install Helm](https://helm.sh/docs/intro/install/)
- **4-node Minikube cluster**: Running and properly labeled
- **kubectl**: Configured to connect to your cluster

### Helm Architecture

```
📁 helm/
├── stanford-students-api/           # Main Helm chart
│   ├── Chart.yaml                   # Chart metadata and dependencies
│   ├── values.yaml                  # Default configuration values
│   └── templates/                   # Kubernetes manifest templates
│       ├── deployment.yaml          # API deployment template
│       ├── service.yaml             # Service template
│       ├── configmap.yaml           # Configuration template
│       ├── secret.yaml              # Secrets template
│       ├── namespace.yaml           # Namespace template
│       └── _helpers.tpl             # Template helpers
├── values-production.yaml           # Production overrides
└── deploy-helm.sh                   # Helm deployment script
```

### Chart Dependencies

The main chart includes community-managed dependencies:
- **PostgreSQL**: Bitnami PostgreSQL chart
- **Vault**: HashiCorp Vault chart
- **External Secrets**: External Secrets Operator chart

### Quick Helm Deployment

#### Step 1: Verify Helm Installation
```bash
helm version
```

#### Step 2: Deploy Using Helm
```bash
cd helm
chmod +x deploy-helm.sh
./deploy-helm.sh
```

### Manual Helm Deployment

#### Step 1: Add Required Repositories
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
```

#### Step 2: Update Dependencies
```bash
cd helm/stanford-students-api
helm dependency update
```

#### Step 3: Install the Chart
```bash
helm install stanford-students-api . \
  --namespace student-api \
  --create-namespace \
  --wait
```

### Helm Management Commands

#### Check Release Status
```bash
helm status stanford-students-api -n student-api
```

#### List All Releases
```bash
helm list -n student-api
```

#### Upgrade Release
```bash
helm upgrade stanford-students-api ./helm/stanford-students-api \
  --namespace student-api
```

#### Rollback Release
```bash
helm rollback stanford-students-api 1 -n student-api
```

#### Uninstall Release
```bash
helm uninstall stanford-students-api -n student-api
```

### Configuration Management

#### Default Values (values.yaml)
```yaml
replicaCount: 2
image:
  repository: stanley80/stanford-students-api
  tag: "latest"
service:
  type: NodePort
  nodePort: 30080
postgresql:
  enabled: true
  auth:
    database: "stanford_students"
vault:
  enabled: true
  server:
    dev:
      enabled: true
```

#### Production Overrides (values-production.yaml)
```bash
# Deploy with production values
helm install stanford-students-api ./helm/stanford-students-api \
  --namespace student-api \
  --create-namespace \
  --values helm/values-production.yaml
```

#### Custom Values Override
```bash
# Override specific values
helm install stanford-students-api ./helm/stanford-students-api \
  --namespace student-api \
  --create-namespace \
  --set replicaCount=3 \
  --set postgresql.auth.postgresPassword=my-secure-password
```

### Helm Best Practices Implemented

- ✅ **Proper Chart Structure**: Standard Helm directory layout
- ✅ **Template Helpers**: Reusable template functions in `_helpers.tpl`
- ✅ **Values Validation**: Proper default values and overrides
- ✅ **Resource Labels**: Consistent labeling using Helm functions
- ✅ **Dependency Management**: Community charts for PostgreSQL, Vault, ESO
- ✅ **Environment Separation**: Different values files for dev/prod
- ✅ **Security**: Secrets managed through Helm templates
- ✅ **Documentation**: Comprehensive Chart.yaml metadata

### Verification Commands

#### Check Deployed Resources
```bash
# View all resources created by Helm
kubectl get all -n student-api -l app.kubernetes.io/managed-by=Helm

# Check pods
kubectl get pods -n student-api

# Check services
kubectl get services -n student-api
```

#### Test Application
```bash
# Get Minikube IP
MINIKUBE_IP=$(minikube ip --profile stanford-students-cluster)

# Test health endpoint
curl http://$MINIKUBE_IP:30080/healthcheck

# Test API
curl http://$MINIKUBE_IP:30080/api/v1/students
```

### Helm Troubleshooting

#### Debug Template Rendering
```bash
# Dry run to see generated manifests
helm install stanford-students-api ./helm/stanford-students-api \
  --namespace student-api \
  --dry-run --debug
```

#### Check Release History
```bash
helm history stanford-students-api -n student-api
```

#### View Release Values
```bash
helm get values stanford-students-api -n student-api
```

#### Check Dependencies
```bash
helm dependency list ./helm/stanford-students-api
```

### Migration from K8s Manifests

If you have existing K8s manifest deployments:

```bash
# Remove old manifest-based deployment
kubectl delete -f k8s/manifests/

# Deploy using Helm
helm install stanford-students-api ./helm/stanford-students-api \
  --namespace student-api \
  --create-namespace
```

### Production Deployment

```bash
# Production deployment with custom values
helm install stanford-students-api ./helm/stanford-students-api \
  --namespace student-api \
  --create-namespace \
  --values helm/values-production.yaml \
  --set postgresql.auth.postgresPassword=$SECURE_DB_PASSWORD \
  --set vault.server.dev.devRootToken=$SECURE_VAULT_TOKEN
```

---

**🎉 Congratulations! Your Stanford Students API is now deployed using Helm Charts!**

### Next Steps
- Explore Helm hooks for advanced deployment scenarios
- Implement Helm tests for automated validation
- Set up GitOps with ArgoCD or Flux for continuous deployment
- Configure monitoring and observability with Prometheus/Grafana charts