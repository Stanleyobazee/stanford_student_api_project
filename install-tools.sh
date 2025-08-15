#!/bin/bash

# Stanford Students API - Tools Installation Script
# Minimal script to install only the essential tools

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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker function
install_docker() {
    log_info "Installing Docker..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux installation
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        
        # Install Docker Compose
        sudo apt-get update
        sudo apt-get install -y docker-compose-plugin
        
        # Start Docker
        sudo systemctl start docker
        sudo systemctl enable docker
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS installation
        if command_exists brew; then
            brew install --cask docker
        else
            log_error "Please install Homebrew first or download Docker Desktop manually"
            exit 1
        fi
    fi
    
    log_success "Docker installed successfully"
}

# Install Make function
install_make() {
    log_info "Installing Make..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y make
        elif command_exists yum; then
            sudo yum install -y make
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists make; then
            xcode-select --install
        fi
    fi
    
    log_success "Make installed successfully"
}

# Install Git function
install_git() {
    log_info "Installing Git..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y git
        elif command_exists yum; then
            sudo yum install -y git
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists git; then
            xcode-select --install
        fi
    fi
    
    log_success "Git installed successfully"
}

# Main function
main() {
    echo -e "${BLUE}🛠️  Installing Essential Tools${NC}"
    echo "=============================="
    echo ""
    
    # Check and install Docker
    if command_exists docker; then
        log_success "Docker already installed: $(docker --version)"
    else
        install_docker
    fi
    
    # Check and install Make
    if command_exists make; then
        log_success "Make already installed: $(make --version | head -n1)"
    else
        install_make
    fi
    
    # Check and install Git
    if command_exists git; then
        log_success "Git already installed: $(git --version)"
    else
        install_git
    fi
    
    echo ""
    log_success "All essential tools are ready!"
    echo ""
    echo "Next steps:"
    echo "1. Clone the repository: git clone <repo-url>"
    echo "2. Navigate to project: cd stanford-uni-students-api"
    echo "3. Run quick start: ./quick-start.sh"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo ""
        log_warning "Please logout and login again for Docker group changes to take effect"
    fi
}

main "$@"