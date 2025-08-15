#!/bin/bash

# Stanford Students API - Complete Setup Script
# This script installs all required tools and sets up the application

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            OS="ubuntu"
        elif [ -f /etc/redhat-release ]; then
            OS="centos"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    log_info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker
install_docker() {
    log_info "Installing Docker..."
    
    case $OS in
        ubuntu)
            # Update package index
            sudo apt-get update
            
            # Install prerequisites
            sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
            
            # Add Docker's GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker repository
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            
            # Add user to docker group
            sudo usermod -aG docker $USER
            
            # Start Docker service
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        centos)
            # Install Docker on CentOS/RHEL
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker $USER
            ;;
        macos)
            # Install Docker Desktop for macOS
            if ! command_exists brew; then
                log_info "Installing Homebrew first..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install --cask docker
            log_warning "Please start Docker Desktop manually after installation"
            ;;
    esac
    
    log_success "Docker installation completed"
}

# Install Make
install_make() {
    log_info "Installing Make..."
    
    case $OS in
        ubuntu)
            sudo apt-get update
            sudo apt-get install -y make
            ;;
        centos)
            sudo yum install -y make
            ;;
        macos)
            # Make is usually pre-installed on macOS
            if ! command_exists make; then
                xcode-select --install
            fi
            ;;
    esac
    
    log_success "Make installation completed"
}

# Install Git
install_git() {
    log_info "Installing Git..."
    
    case $OS in
        ubuntu)
            sudo apt-get update
            sudo apt-get install -y git
            ;;
        centos)
            sudo yum install -y git
            ;;
        macos)
            if ! command_exists git; then
                xcode-select --install
            fi
            ;;
    esac
    
    log_success "Git installation completed"
}

# Install Go (optional for local development)
install_go() {
    if [ "$1" = "--skip-go" ]; then
        log_info "Skipping Go installation (Docker-only setup)"
        return
    fi
    
    log_info "Installing Go..."
    
    GO_VERSION="1.21.5"
    
    case $OS in
        ubuntu|centos)
            # Download and install Go
            wget -q https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
            rm go${GO_VERSION}.linux-amd64.tar.gz
            
            # Add Go to PATH
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
            echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
            export PATH=$PATH:/usr/local/go/bin
            ;;
        macos)
            if command_exists brew; then
                brew install go
            else
                # Download and install Go manually
                curl -L https://golang.org/dl/go${GO_VERSION}.darwin-amd64.tar.gz -o go${GO_VERSION}.darwin-amd64.tar.gz
                sudo rm -rf /usr/local/go
                sudo tar -C /usr/local -xzf go${GO_VERSION}.darwin-amd64.tar.gz
                rm go${GO_VERSION}.darwin-amd64.tar.gz
                echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
            fi
            ;;
    esac
    
    log_success "Go installation completed"
}

# Verify installations
verify_tools() {
    log_info "Verifying tool installations..."
    
    local all_good=true
    
    if command_exists docker; then
        log_success "Docker: $(docker --version)"
    else
        log_error "Docker installation failed"
        all_good=false
    fi
    
    if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
        if command_exists docker-compose; then
            log_success "Docker Compose: $(docker-compose --version)"
        else
            log_success "Docker Compose: $(docker compose version)"
        fi
    else
        log_error "Docker Compose installation failed"
        all_good=false
    fi
    
    if command_exists make; then
        log_success "Make: $(make --version | head -n1)"
    else
        log_error "Make installation failed"
        all_good=false
    fi
    
    if command_exists git; then
        log_success "Git: $(git --version)"
    else
        log_error "Git installation failed"
        all_good=false
    fi
    
    if command_exists go; then
        log_success "Go: $(go version)"
    else
        log_warning "Go not installed (Docker-only setup)"
    fi
    
    if [ "$all_good" = true ]; then
        log_success "All required tools are installed!"
    else
        log_error "Some tools failed to install. Please check the errors above."
        exit 1
    fi
}

# Setup application
setup_application() {
    log_info "Setting up Stanford Students API..."
    
    # Copy environment file
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            log_success "Created .env file from .env.example"
            log_warning "Please edit .env file with your database credentials"
        else
            log_error ".env.example file not found"
            exit 1
        fi
    else
        log_info ".env file already exists"
    fi
    
    # Create necessary directories
    mkdir -p postgres_data logs screenshots
    log_success "Created necessary directories"
    
    log_success "Application setup completed!"
}

# Main installation function
main() {
    echo "🚀 Stanford Students API - Complete Setup"
    echo "========================================"
    echo ""
    
    # Parse arguments
    SKIP_GO=false
    for arg in "$@"; do
        case $arg in
            --skip-go)
                SKIP_GO=true
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --skip-go    Skip Go installation (Docker-only setup)"
                echo "  --help, -h   Show this help message"
                echo ""
                exit 0
                ;;
        esac
    done
    
    # Detect operating system
    detect_os
    
    # Install tools
    if ! command_exists docker; then
        install_docker
    else
        log_success "Docker already installed: $(docker --version)"
    fi
    
    if ! command_exists make; then
        install_make
    else
        log_success "Make already installed: $(make --version | head -n1)"
    fi
    
    if ! command_exists git; then
        install_git
    else
        log_success "Git already installed: $(git --version)"
    fi
    
    if [ "$SKIP_GO" = false ]; then
        if ! command_exists go; then
            install_go
        else
            log_success "Go already installed: $(go version)"
        fi
    else
        install_go --skip-go
    fi
    
    # Verify installations
    verify_tools
    
    # Setup application
    setup_application
    
    echo ""
    echo "🎉 Setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Edit .env file with your database credentials"
    echo "2. Run: make run-api"
    echo "3. Access: http://localhost:8080"
    echo ""
    
    if [ "$OS" = "ubuntu" ] || [ "$OS" = "centos" ]; then
        log_warning "Please logout and login again for Docker group changes to take effect"
        log_info "Or run: newgrp docker"
    fi
}

# Run main function
main "$@"