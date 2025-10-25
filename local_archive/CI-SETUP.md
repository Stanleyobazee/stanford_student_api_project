# CI/CD Pipeline Setup Guide

This guide explains how to set up the GitHub Actions CI pipeline for the Stanford Students API project.

## Pipeline Overview

The CI pipeline consists of the following stages:
1. **Build API** - Uses `make build-api`
2. **Run Tests** - Uses `make test`
3. **Code Linting** - Uses `make lint`
4. **Docker Login** - Authenticates with Docker Hub
5. **Docker Build and Push** - Builds and pushes to Docker registry

## Prerequisites

### 1. Docker Hub Account
- Create account at [Docker Hub](https://hub.docker.com/)
- Note your username for later use

### 2. AWS EC2 Instance
- Ubuntu 20.04 or later
- At least 2GB RAM, 20GB storage
- Security group allowing SSH (port 22)

## Setup Instructions

### Step 1: Set up Self-Hosted Runner on AWS EC2

1. **Connect to your EC2 instance:**
   ```bash
   ssh -i your-key.pem ubuntu@your-ec2-ip
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/Stanleyobazee/stanford_student_api_project.git
   cd stanford_student_api_project
   ```

3. **Run the runner setup script:**
   ```bash
   chmod +x setup-runner.sh
   ./setup-runner.sh
   ```

4. **Logout and login again** for Docker permissions to take effect:
   ```bash
   exit
   ssh -i your-key.pem ubuntu@your-ec2-ip
   ```

### Step 2: Configure GitHub Runner

1. **Go to your GitHub repository**
2. **Navigate to Settings > Actions > Runners**
3. **Click "New self-hosted runner"**
4. **Select Linux x64**
5. **Copy the configuration command** and run it in the runner directory:
   ```bash
   cd ~/actions-runner
   ./config.sh --url https://github.com/Stanleyobazee/stanford_student_api_project --token YOUR_TOKEN
   ```

6. **Start the runner:**
   ```bash
   ./run.sh
   ```

   Or install as a service:
   ```bash
   sudo ./svc.sh install
   sudo ./svc.sh start
   ```

### Step 3: Configure GitHub Secrets

1. **Go to your repository Settings > Secrets and variables > Actions**
2. **Add the following secrets:**
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password or access token

### Step 4: Test the Pipeline

1. **Make a code change** in any of these directories:
   - `controllers/`, `models/`, `routes/`, `tests/`, `config/`, `database/`, `web/`
   - Or modify: `*.go`, `go.mod`, `go.sum`, `Dockerfile`, `docker-compose.yml`, `Makefile`

2. **Commit and push:**
   ```bash
   git add .
   git commit -m "Test CI pipeline"
   git push origin main
   ```

3. **Check the Actions tab** in your GitHub repository to see the pipeline running

## Pipeline Triggers

The pipeline runs on:
- **Push to main/develop branches** (only for code changes)
- **Pull requests to main branch** (only for code changes)
- **Manual trigger** via GitHub Actions UI

## Pipeline Features

### Path-based Triggers
- Only runs when code files are changed
- Ignores documentation, README, and other non-code changes

### Make Targets Used
- `make deps` - Install Go dependencies
- `make fmt` - Format code and check formatting
- `make lint` - Run code linting with golangci-lint
- `make build-api` - Build Docker image
- `make test` - Run unit tests
- `make clean` - Clean up artifacts

### Docker Registry
- Pushes to Docker Hub with tags:
  - `your-username/stanford-students-api:v1`
  - `your-username/stanford-students-api:latest`

## Troubleshooting

### Runner Issues
```bash
# Check runner status
cd ~/actions-runner
./run.sh

# View runner logs
sudo journalctl -u actions.runner.* -f
```

### Docker Issues
```bash
# Check Docker permissions
docker ps

# If permission denied:
sudo usermod -aG docker $USER
# Then logout and login again
```

### Go Issues
```bash
# Check Go installation
go version

# If not found, add to PATH:
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

### Pipeline Failures
- Check the Actions tab in GitHub for detailed logs
- Ensure all secrets are properly configured
- Verify the runner is online and connected

## Manual Pipeline Trigger

You can manually trigger the pipeline:
1. Go to Actions tab in GitHub
2. Select "CI Pipeline" workflow
3. Click "Run workflow"
4. Choose branch and click "Run workflow"

## Security Notes

- Runner has access to your repository code
- Use GitHub secrets for sensitive data
- Regularly update the runner and dependencies
- Monitor runner logs for suspicious activity