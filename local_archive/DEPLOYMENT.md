# Production Deployment Guide

This guide covers deploying the Stanford Students API in a production environment using Vagrant, Docker, and Nginx load balancing.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Vagrant VM (Production)                  │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                 Docker Network                          │ │
│  │                                                         │ │
│  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │ │
│  │  │    Nginx    │    │    App1     │    │    App2     │ │ │
│  │  │Load Balancer│◄──►│  (API)      │    │  (API)      │ │ │
│  │  │   :80       │    │   :8081     │    │   :8082     │ │ │
│  │  └─────────────┘    └─────────────┘    └─────────────┘ │ │
│  │         │                   │                   │      │ │
│  │         │                   └───────────────────┘      │ │
│  │         │                           │                  │ │
│  │         │            ┌─────────────────────────────┐   │ │
│  │         │            │         PostgreSQL          │   │ │
│  │         │            │        Database             │   │ │
│  │         │            │         :5432               │   │ │
│  │         │            └─────────────────────────────┘   │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
   Host: localhost:8080
```

## Components

- **2 API Containers**: Load-balanced Go API instances
- **1 Database Container**: PostgreSQL database
- **1 Nginx Container**: Load balancer and reverse proxy
- **Vagrant VM**: Production environment simulation

## Quick Start

### 1. Prerequisites

✅ **Already installed on your Windows machine:**
- Vagrant
- Oracle VirtualBox
- Git (for cloning repository)

### 2. Deploy to Production

**On Windows Command Prompt/PowerShell:**
```cmd
# Navigate to project directory
cd c:\Users\Stanley\stanford-uni-students-api\stanford_student_api_project

# Start Vagrant VM
vagrant up

# SSH into VM
vagrant ssh
```

**Inside the VM:**
```bash
# Navigate to synced project folder
cd /vagrant

# Start load-balanced deployment
make run-api
```

### 3. Access Application

- **API Endpoint**: http://localhost:8080
- **Health Check**: http://localhost:8080/healthcheck
- **Load Balancer Health**: http://localhost:8080/health

## Deployment Commands

### Vagrant Management (Windows Host)
```cmd
# From Windows Command Prompt in project directory
vagrant up          # Start VM
vagrant ssh         # SSH into VM
vagrant halt        # Stop VM
vagrant destroy     # Delete VM
vagrant reload      # Restart VM
vagrant status      # Check VM status
```

### Application Management (Inside VM)
```bash
make run-api        # Start load-balanced deployment
make status         # Check service status
make stop-all       # Stop all services
make clean          # Clean up containers and data
```

## Load Balancing

### Nginx Configuration
- **Algorithm**: Round-robin (default)
- **Health Checks**: Automatic failover
- **Upstream Servers**: app1:8081, app2:8082

### Testing Load Balancing
```bash
# Multiple requests to see load distribution
for i in {1..10}; do
  curl -s http://localhost:8080/healthcheck | jq .
  sleep 1
done
```

## Monitoring

### Container Status
```bash
# Check all containers
docker compose ps

# Check specific services
docker compose logs app1
docker compose logs app2
docker compose logs nginx
docker compose logs postgres
```

### Resource Usage
```bash
# Container resource usage
docker stats

# System resources
htop
```

## Troubleshooting

### Common Issues

1. **Port 8080 in use**
   ```bash
   sudo lsof -i :8080
   make stop-all
   ```

2. **Database connection issues**
   ```bash
   docker compose logs postgres
   make start-db
   ```

3. **Load balancer not working**
   ```bash
   docker compose logs nginx
   # Check nginx/nginx.conf configuration
   ```

### Health Checks

```bash
# API health
curl http://localhost:8080/healthcheck

# Individual API instances (inside VM)
curl http://app1:8081/healthcheck
curl http://app2:8082/healthcheck

# Nginx health
curl http://localhost:8080/health
```

## Production Considerations

### Security
- Change default passwords in `.env`
- Use HTTPS in production
- Implement proper authentication
- Regular security updates

### Scaling
- Add more API instances by modifying `docker-compose.yml`
- Update Nginx upstream configuration
- Consider container orchestration (Kubernetes)

### Monitoring
- Implement logging aggregation
- Set up metrics collection
- Configure alerting

### Backup
- Regular database backups
- Configuration backup
- Disaster recovery plan

## File Structure

```
stanford_student_api_project/
├── Vagrantfile                 # VM configuration
├── docker-compose.yml          # Multi-container setup
├── nginx/
│   └── nginx.conf             # Load balancer config
├── scripts/
│   └── setup-production.sh    # Production setup script
└── DEPLOYMENT.md              # This file
```

## Environment Variables

Required in `.env` file:
```bash
POSTGRES_DB=stanford_students
POSTGRES_USER=admin_stan
POSTGRES_PASSWORD=secure_password_123
PORT=8080
LOG_LEVEL=info
```

## Windows Host Specific Notes

### File Syncing
- Project files are automatically synced between Windows host and VM via `/vagrant`
- Changes made on Windows are reflected in the VM
- Database data persists in `postgres_data/` on Windows host

### Port Forwarding
- VM forwards port 8080 to Windows host
- Access API from Windows: http://localhost:8080
- Database accessible on Windows: localhost:5433

### Performance Tips
- Allocate sufficient RAM to VM (2GB configured)
- Close unnecessary applications on Windows
- Use SSD for better VM performance

### Windows Commands
```cmd
# Check if ports are available on Windows
netstat -an | findstr :8080
netstat -an | findstr :5433

# Stop processes using ports (if needed)
taskkill /F /PID <process_id>
```

## Support

For deployment issues:
1. **VM Issues**: Check `vagrant status` and VirtualBox console
2. **Container logs**: `docker compose logs [service]` (inside VM)
3. **Network connectivity**: `docker network ls` (inside VM)
4. **Resource usage**: `docker stats` (inside VM)
5. **Windows host**: Check port conflicts and firewall settings