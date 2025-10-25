#!/bin/bash

echo "=== Starting 4-Node Minikube Cluster ==="
echo

# Delete any existing cluster
echo "Cleaning up existing clusters..."
minikube delete --all 2>/dev/null || true

# Start new 4-node cluster
echo "Starting new 4-node Minikube cluster..."
minikube start --nodes 4 --cpus 2 --memory 2048 --driver docker

# Verify cluster
echo
echo "=== Cluster Status ==="
minikube status

echo
echo "=== Node Information ==="
kubectl get nodes

echo
echo "=== Cluster Ready ==="