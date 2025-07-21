#  Node.js App Deployment on AWS EKS using Terraform, Docker, Helm & NGINX Ingress

## Project Overview

This project demonstrates how to containerize and deploy a **Node.js application** on AWS Elastic Kubernetes Service (EKS) using:

* ✅ **Docker** for containerizing the Node.js application
* ✅ **Terraform** for provisioning infrastructure (VPC, Subnets, EKS cluster, and node group)
* ✅ **Helm** for packaging and deploying the app to Kubernetes
* ✅ **NGINX Ingress Controller** for load-balanced access to the app
* ✅ **AWS Load Balancer** for external accessibility

---

## Prerequisites

Before running this project, ensure you have:

- AWS CLI configured with access keys
- Terraform installed
- Docker installed and running
- kubectl installed and configured
- Helm installed
- An AWS account with permissions to create VPC, EKS, IAM roles, etc.

---

## Tools used 

| Component           | Tool Used                |
| ------------------- | ------------------------ |
| Infrastructure      | Terraform                |
| Kubernetes Platform | AWS EKS                  |
| App Deployment      | Helm                     |
| Containerization    | Docker                   |
| Ingress             | NGINX Ingress Controller |
| Load Balancing      | AWS ELB                  |

---

## Features

- Fully Automated Infrastructure using Terraform for provisioning VPC, Subnets, EKS Cluster, and Node Group on AWS.
- Containerized Node.js App with a custom Dockerfile for consistent deployment across environments.
- Helm-Powered Kubernetes Deployment: Simplifies app deployment and management in EKS.
- NGINX Ingress Controller routes traffic and enables clean load-balanced access to your app.
- AWS Load Balancer Integration for public access with high availability.
- Clean Modular Structure separating Terraform, Docker, and Helm components for easy collaboration and scaling.
- Multi-Step Terraform Apply logic for managing EKS auth config dynamically.
- Production-Ready Workflow suitable for CI/CD, DevOps interviews, and real-world team setups.

## How It Works

This project automates the deployment of a Node.js app on a Kubernetes cluster (AWS EKS) using Terraform, Docker, Helm, and Ingress.

- Terraform provisions the AWS infrastructure:

  VPC, public/private subnets

  EKS cluster and node group

  IAM roles and networking

- A Node.js app is containerized using Docker and pushed to Docker Hub.

- Helm is used to deploy the app into EKS:

  Helm templates generate Kubernetes YAMLs for Deployment, Service, Ingress, etc.

- An NGINX Ingress Controller is installed to manage external traffic into the cluster.

- AWS Load Balancer is automatically provisioned by the Ingress controller to expose the app publicly.

- You access the app via the Load Balancer DNS URL, confirming successful end-to-end deployment.

---

## Architecture Diagram

<img width="647" height="749" alt="eks-nodejs-diagram" src="https://github.com/user-attachments/assets/ddfcae18-61b8-48bc-a64b-7f94f6f538a7" />

---

##  Project Structure

```bash
eks-helm-project/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
├── app/
│   ├── Dockerfile
│   ├── index.js
│   └── package.json
├── my-app/
│   ├── charts/
│   ├── templates/
│   │   ├── tests/test-connection.yaml
│   │   ├── _helpers.tpl
│   │   ├── deployment.yaml
│   │   ├── hpa.yaml
│   │   ├── ingress.yaml
│   │   ├── NOTES.txt
│   │   ├── service.yaml
│   │   └── serviceaccount.yaml
│   ├── .helmignore
│   ├── Chart.yaml
│   └── values.yaml
├── .gitignore
└── README.md
```

---

##  Step 1: Clone the Repo

```bash
git clone https://github.com/Shravani3001/eks-helm-project.git
cd eks-helm-project
```

##  Step 2: Provision Infrastructure using Terraform

Navigate to the `terraform/` folder and initialize Terraform:

```bash
cd terraform
terraform init
```

###  Apply in Two Phases (Due to EKS Dependency)

#### Phase 1:

1. In `providers.tf`, comment out the `kubernetes` provider block **AND** the `data` blocks:

```bash
# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_name
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_name
# }

# provider "kubernetes" {
#   host = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#   token = data.aws_eks_cluster_auth.cluster.token
# }
```

2. In `main.tf`, set this:

```bash
manage_aws_auth_configmap = false
```

3. Run:

```bash
terraform apply
```

#### Phase 2:

1. Uncomment the data blocks and Kubernetes provider block
2. In `main.tf`, change this:
```bash
manage_aws_auth_configmap = true
```

3. Apply again:

```bash
terraform apply
```

4. Update your kubeconfig so kubectl can access the EKS cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name eks_cluster 
```

5. Verify node group is registered:

```bash
kubectl get nodes
```

##  Step 3: Containerize the Node.js App

1. Navigate to the app folder:

```bash
cd ../app
```

2. Make sure Docker Desktop is running

3. Build and push the Docker image:

```bash
docker build -t your-dockerhub-username/app .
docker push your-dockerhub-username/app
```

##  Step 4: Deploy the App Using Helm

### Create a Helm Chart

From your project root:

```bash
helm create my-app
```

This generates a Helm chart with default files.

Edit values.yaml

Update the following fields:
```bash
image:
  repository: your-dockerhub-username/app
  pullPolicy: IfNotPresent
  tag: latest

service:
  type: ClusterIP
  port: 3000

ingress:
  enabled: true
  className: "nginx"
  annotations: 
    kubernetes.io/ingress.class: nginx
  hosts:
    - host: ""
      paths:
        - path: /
          pathType: Prefix
          backend:
          service:
            name: node.js-service
            port:
              number: 3000
```

### Deploy Using Helm

```bash
helm install my-app ./my-app
```

**Verify:**
```bash
kubectl get pods
kubectl get deployments
kubectl get svc
```

##  Step 5: Install NGINX Ingress Controller

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx
```

**Verify ELB DNS:**
```bash
kubectl get svc -n ingress-nginx
```

Look for the LoadBalancer EXTERNAL-IP (AWS ELB DNS).

##  Step 6: Access the App in Browser

**Example output:**
```bash
NAME     HOSTS             ADDRESS                                                                   PORTS
my-app   myapp.local       abc123456789.elb.amazonaws.com                                           80
```

**Open in browser:**
```bash
http://abc123456789.elb.amazonaws.com
```

You should see:

```
🚀 Hello from Shravani's CI/CD Node.js App!
```

---


---

## About Me

I'm Shravani, a self-taught and project-driven DevOps engineer passionate about building scalable infrastructure and automating complex workflows.

I love solving real-world problems with tools like Terraform, Ansible, Docker, Jenkins, and AWS — and I’m always learning something new to sharpen my edge in DevOps.

**Connect with me:**

[LinkedIn](https://www.linkedin.com/in/shravani3001) 

[GitHub](https://github.com/Shravani3001)


