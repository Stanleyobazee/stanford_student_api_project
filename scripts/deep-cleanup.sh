#!/bin/bash

echo "=== EC2 Deep Cleanup Script ==="
echo "This will clean Docker, Minikube, and system resources"
echo

# Stop all running containers
echo "Stopping all Docker containers..."
sudo docker stop $(sudo docker ps -aq) 2>/dev/null || true

# Remove all containers
echo "Removing all Docker containers..."
sudo docker rm $(sudo docker ps -aq) 2>/dev/null || true

# Remove all images
echo "Removing all Docker images..."
sudo docker rmi $(sudo docker images -q) --force 2>/dev/null || true

# Clean Docker system
echo "Cleaning Docker system (containers, networks, images, volumes)..."
sudo docker system prune -af --volumes

# Clean Minikube
echo "Cleaning Minikube clusters..."
minikube delete --all 2>/dev/null || true

# Clean package cache
echo "Cleaning package cache..."
sudo apt-get clean
sudo apt-get autoremove -y

# Clean logs
echo "Cleaning system logs..."
sudo journalctl --vacuum-time=1d

# Clean temp files
echo "Cleaning temporary files..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Show disk usage after cleanup
echo
echo "=== Disk Usage After Cleanup ==="
df -h

echo
echo "=== Cleanup Complete ==="