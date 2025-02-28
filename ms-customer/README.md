# MS-Customer Application

This is a Spring Boot application for managing customer data. It uses an H2 database for storage and is containerized using Docker. 
The application can be deployed locally using Kubernetes (Minikube).

## Table of Contents
1. [Project Structure](#project-structure)
2. [Prerequisites](#prerequisites)
3. [Building the Application](#building-the-application)
4. [Running the Application Locally](#running-the-application-locally)
5. [Containerizing the Application](#containerizing-the-application)
6. [Deploying to Kubernetes](#deploying-to-kubernetes)
7. [Accessing the Application](#accessing-the-application)
8. [Troubleshooting](#troubleshooting)

---

## Project Structure
ms-customer/
├── Dockerfile
├── HELP.md
├── README.md
├── data/
│ └── customerdb.mv.db
├── deployment.yaml
├── mvnw
├── mvnw.cmd
├── pom.xml
├── service.yaml
├── src/
│ ├── main/
│ │ ├── java/
│ │ │ └── tn/
│ │ │ └── iteam/
│ │ │ ├── MsCustomerApplication.java
│ │ │ ├── entities/
│ │ │ │ └── Customer.java
│ │ │ └── repos/
│ │ │ └── CustomerRepository.java
│ │ └── resources/
│ │ ├── application.properties
│ │ ├── data.sql
│ │ ├── static/
│ │ └── templates/
│ └── test/
│ └── java/
│ └── tn/
│ └── iteam/
│ └── MsCustomerApplicationTests.java
└── target/
└── ms-customer-0.0.1-SNAPSHOT.jar

---

## Prerequisites

Before you begin, ensure you have the following installed:

- **Java 17**: The application is built using Java 17.
- **Maven**: For building the project.
- **Docker**: For containerizing the application.
- **Kubernetes (Minikube)**: For local deployment.
- **kubectl**: Kubernetes command-line tool.
---

## Building the Application

To build the application, run the following command:

```bash
./mvnw clean package

This will generate a JAR file in the target/ directory.

Running the Application Locally
To run the application locally, use the following command:

java -jar target/ms-customer-0.0.1-SNAPSHOT.jar
The application will start on port 8085. You can access it at http://localhost:8085.

Containerizing the Application
To containerize the application, build the Docker image:
docker build -t oussama132/ms-customer-app:1.0 .

Verify the image was created:
docker images

Deploying to Kubernetes
1. Start Minikube
If you're using Minikube, start it:
minikube start

Set Minikube to use the local Docker daemon:
eval $(minikube docker-env)

Rebuild the Docker image in Minikube's context:
docker build -t ms-customer:latest .

2. Apply Kubernetes Configuration
Apply the Kubernetes deployment and service:

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

3. Verify Deployment
Check the status of the deployment:
kubectl get pods
kubectl get services

Accessing the Application
If you're using Minikube, access the application using:

minikube service ms-customer
This will open the application in your default browser.

Troubleshooting
1. ImagePullBackOff Error
If you encounter an ImagePullBackOff error, ensure the Docker image is available in Minikube's Docker registry:

eval $(minikube docker-env)
docker images

2. Check Pod Logs
To debug issues, check the pod logs:

kubectl logs <pod-name>

3. Describe Pod
For more details, describe the pod:

kubectl describe pod <pod-name>

