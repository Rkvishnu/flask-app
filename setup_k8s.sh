#!/bin/bash

# Install dependencies
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y curl apt-transport-https virtualbox virtualbox-ext-pack

# Install Minikube
echo "Installing Minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

# Install kubectl
echo "Installing kubectl..."
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.27.4/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Start Minikube cluster
echo "Starting Minikube..."
minikube start --driver=virtualbox

# Set up kubectl context
echo "Configuring kubectl..."
kubectl config use-context minikube

# Apply Kubernetes YAML files
echo "Deploying Flask app..."
kubectl apply -f k8s/Deployment.yaml
kubectl apply -f k8s/Service.yaml

# Verify Deployment
kubectl rollout status deployment/flask-app
kubectl get pods
