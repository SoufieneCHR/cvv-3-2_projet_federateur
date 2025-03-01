#!/bin/bash

# Function to check if Helm is installed
check_helm_installed() {
    if command -v helm &> /dev/null; then
        echo "Helm is already installed."
        echo "Installed Helm version:"
        helm version
    else
        echo "Helm is not installed. Proceeding with installation..."
        install_helm
    fi
}

# Function to install Helm using the official get_helm.sh script
install_helm() {
    echo "Downloading the official Helm installation script..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

    if [ $? -ne 0 ]; then
        echo "Error: Failed to download the Helm installation script."
        exit 1
    fi

    echo "Making the Helm installation script executable..."
    chmod 700 get_helm.sh

    echo "Running the Helm installation script..."
    ./get_helm.sh

    if [ $? -eq 0 ]; then
        echo "Helm has been successfully installed."
        echo "Installed Helm version:"
        helm version
        rm -f get_helm.sh  # Clean up the installation script
    else
        echo "Helm installation failed."
        rm -f get_helm.sh  # Clean up the installation script
        exit 1
    fi
}

# Function to install MLflow using Helm
install_mlflow() {
    echo "Adding community-charts repository..."
    helm repo add community-charts https://community-charts.github.io/helm-charts

    echo "Updating Helm repositories..."
    helm repo update

    echo "Installing MLflow chart..."
    helm install my-mlflow community-charts/mlflow --version 0.7.19

    if [ $? -eq 0 ]; then
        echo "MLflow has been successfully installed."
    else
        echo "MLflow installation failed."
        exit 1
    fi
}

# Function to expose MLflow URL
expose_mlflow_url() {
    echo "Waiting for MLflow pod to be ready..."
    sleep 160  #

    # Get the pod name
    POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=mlflow,app.kubernetes.io/instance=my-mlflow" -o jsonpath="{.items[0].metadata.name}")
    if [ -z "$POD_NAME" ]; then
        echo "Error: MLflow pod not found."
        exit 1
    fi

    # Get the container port
    CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
    if [ -z "$CONTAINER_PORT" ]; then
        echo "Error: Container port not found."
        exit 1
    fi

    # Expose the service (if not already exposed)
    echo "Exposing MLflow service..."
    kubectl expose pod $POD_NAME --type=NodePort --port=$CONTAINER_PORT --name=my-mlflow-service

    # Get the NodePort
    NODE_PORT=$(kubectl get svc my-mlflow-service --namespace default -o jsonpath="{.spec.ports[0].nodePort}")
    if [ -z "$NODE_PORT" ]; then
        echo "Error: Unable to retrieve NodePort."
        exit 1
    fi

    # Get the cluster IP or node IP
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
    if [ -z "$NODE_IP" ]; then
        NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
    fi

    # Print the access URL
    echo "MLflow is accessible at: http://${NODE_IP}:${NODE_PORT}"
}

# Main script execution
echo "Checking Helm installation..."
check_helm_installed

echo "Installing MLflow..."
install_mlflow

echo "Exposing MLflow URL..."
expose_mlflow_url

echo "Setup complete!"
