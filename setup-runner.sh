#!/bin/bash

# GitHub Actions Self-Hosted Runner Setup Script for AWS EC2

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    log_error "Please don't run this script as root"
    exit 1
fi

log_info "Setting up GitHub Actions Self-Hosted Runner on AWS EC2"
echo "============================================================"

# Update system
log_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
log_info "Installing required packages..."
sudo apt install -y curl wget git make build-essential

# Install Docker
if ! command -v docker &> /dev/null; then
    log_info "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo systemctl start docker
    sudo systemctl enable docker
    rm get-docker.sh
    log_success "Docker installed"
else
    log_success "Docker already installed"
fi

# Install Docker Compose
if ! docker compose version &> /dev/null; then
    log_info "Installing Docker Compose..."
    sudo apt install -y docker-compose-plugin
    log_success "Docker Compose installed"
else
    log_success "Docker Compose already installed"
fi

# Install Go
if ! command -v go &> /dev/null; then
    log_info "Installing Go..."
    GO_VERSION="1.21.5"
    wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
    rm go${GO_VERSION}.linux-amd64.tar.gz
    
    # Add Go to PATH
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
    
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    
    log_success "Go installed"
else
    log_success "Go already installed"
fi

# Create runner directory
RUNNER_DIR="$HOME/actions-runner"
mkdir -p $RUNNER_DIR
cd $RUNNER_DIR

# Download GitHub Actions runner
log_info "Downloading GitHub Actions runner..."
RUNNER_VERSION="2.311.0"
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract runner
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install dependencies
sudo ./bin/installdependencies.sh

log_success "Runner setup completed!"
echo ""
log_warning "Next steps:"
echo "1. Go to your GitHub repository settings"
echo "2. Navigate to Actions > Runners"
echo "3. Click 'New self-hosted runner'"
echo "4. Copy the configuration command and run it in: $RUNNER_DIR"
echo "5. Example: ./config.sh --url https://github.com/YOUR_USERNAME/stanford_student_api_project --token YOUR_TOKEN"
echo "6. Start the runner: ./run.sh"
echo ""
log_info "To run as a service:"
echo "sudo ./svc.sh install"
echo "sudo ./svc.sh start"
echo ""
log_warning "Please logout and login again for Docker group changes to take effect"