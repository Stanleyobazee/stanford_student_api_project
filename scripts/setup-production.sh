#!/bin/bash

# Stanford Students API Production Setup Script
# This script sets up the production environment with all required dependencies

set -e

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to install Docker
install_docker() {
    log "Installing Docker..."
    
    # Update package index
    apt-get update
    
    # Install required packages
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up Docker repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    apt-get update
    
    # Install Docker Engine
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add vagrant user to docker group
    usermod -aG docker vagrant
    
    # Start and enable Docker
    systemctl start docker
    systemctl enable docker
    
    log "Docker installed successfully"
}

# Function to install additional tools
install_tools() {
    log "Installing additional tools..."
    
    # Install make, git, and other utilities
    apt-get install -y \
        make \
        git \
        curl \
        wget \
        unzip \
        htop \
        tree \
        jq
    
    log "Additional tools installed"
}

# Function to install Go
install_go() {
    log "Installing Go..."
    
    # Download and install Go
    GO_VERSION="1.21.5"
    wget -q https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
    rm -rf /usr/local/go
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
    rm go${GO_VERSION}.linux-amd64.tar.gz
    
    # Add Go to PATH for all users
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc
    
    log "Go installed successfully"
}

# Function to setup environment
setup_environment() {
    log "Setting up environment..."
    
    # Create environment file if it doesn't exist
    if [ ! -f /vagrant/.env ]; then
        cat > /vagrant/.env << EOF
POSTGRES_DB=stanford_students
POSTGRES_USER=admin_stan
POSTGRES_PASSWORD=secure_password_123
PORT=8080
LOG_LEVEL=info
EOF
        chown vagrant:vagrant /vagrant/.env
        log "Environment file created"
    fi
    
    # Set proper permissions
    chown -R vagrant:vagrant /vagrant
    
    log "Environment setup completed"
}

# Function to test installation
test_installation() {
    log "Testing installation..."
    
    # Test Docker
    if docker --version > /dev/null 2>&1; then
        log "✅ Docker is working"
    else
        log "❌ Docker installation failed"
        exit 1
    fi
    
    # Test Docker Compose
    if docker compose version > /dev/null 2>&1; then
        log "✅ Docker Compose is working"
    else
        log "❌ Docker Compose installation failed"
        exit 1
    fi
    
    # Test Make
    if make --version > /dev/null 2>&1; then
        log "✅ Make is working"
    else
        log "❌ Make installation failed"
        exit 1
    fi
    
    log "All installations verified successfully"
}

# Main execution
main() {
    log "Starting Stanford Students API production setup..."
    
    # Update system
    log "Updating system packages..."
    apt-get update && apt-get upgrade -y
    
    # Install components
    install_docker
    install_tools
    install_go
    setup_environment
    test_installation
    
    log "Production environment setup completed successfully!"
    log "You can now run 'cd /vagrant && make run-api' to start the application"
}

# Run main function
main "$@"