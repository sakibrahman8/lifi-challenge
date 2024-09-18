# Bird Application - DevOps Challenge Documentation

## Overview

This project was a great opportunity to showcase my DevOps skills by working on the Bird Application, which consists of two APIs (`bird` and `birdImage`). The challenge was to containerize the app, set up infrastructure on AWS using Infrastructure as Code (IaC), deploy it on Kubernetes, and add observability. Here’s how I tackled each part of the challenge and what I accomplished.

## What I Did and How It Went

### 1. **Dockerization of Applications**

- **Goal**: To containerize both APIs for consistency and ease of deployment.
- **What I Did**:
  - Created Dockerfiles for both the `bird` and `birdImage` APIs using multi-stage builds. This means the final images are as small as possible since they don’t include unnecessary build tools or dependencies.
  - Focused on security by adding a non-root user in the container, which is a crucial step to prevent potential security vulnerabilities.
  - Chose `alpine` as the base image for the final stage to keep the image lightweight and secure.

  **Outcome**: Ended up with lightweight, secure Docker images for each API that can be deployed anywhere.

### 2. **Infrastructure as Code (IaC) with Terraform**

- **Goal**: Automate the AWS infrastructure setup using Terraform.
- **What I Did**:
  - Used a modular approach in Terraform to set up a VPC, security groups, and EC2 instances. This made the code more reusable and easier to maintain.
  - Defined strict ingress and egress rules for the security groups to enhance the security of the environment.
  - Included outputs in the Terraform configuration to easily get important information like EC2 instance public IPs, making the deployment process smoother.

  **Outcome**: Created a fully automated, secure, and scalable cloud environment on AWS that follows best practices.

### 3. **Kubernetes Deployment with Helm**

- **Goal**: Deploy the applications on Kubernetes and manage them using Helm.
- **What I Did**:
  - Developed Helm charts for both APIs, including configurations for deployment, services, and horizontal pod autoscaling.
  - Made sure to include security contexts in the Helm charts to ensure the containers run as non-root users with limited permissions, enhancing security.
  - Added resource requests and limits to the Helm charts, which is key to managing resources efficiently and avoiding overconsumption.

  **Outcome**: Successfully deployed the applications on Kubernetes using Helm, with built-in security and scalability.

### 4. **Observability with Prometheus**

- **Goal**: Implement monitoring to keep track of the applications and the Kubernetes cluster.
- **What I Did**:
  - Used Helm to deploy Prometheus, leveraging the `kube-prometheus-stack` for a complete monitoring solution.
  - Customized Prometheus settings to fit the specific needs of the Bird Application.
  - Integrated the Go applications with Prometheus to expose metrics, giving visibility into how the applications are performing.

  **Outcome**: Set up a solid monitoring solution that provides insights into the health and performance of both the applications and the Kubernetes cluster.

### 5. **CI/CD Pipeline with GitHub Actions**

- **Goal**: Automate the build, test, and deployment process to ensure quick and reliable delivery.
- **What I Did**:
  - Created a GitHub Actions workflow (`deploy.yml`) to build and push Docker images to AWS ECR, and deploy them to Kubernetes using Helm.
  - Used GitHub Secrets to securely handle AWS credentials, ensuring sensitive data isn't exposed.
  - Set up another workflow (`terraform.yml`) to provision the infrastructure using Terraform, including validation and plan steps to maintain control over changes.

  **Outcome**: Built an automated CI/CD pipeline that streamlines the entire process from code to deployment, reducing manual work and risk of errors.

## Wrapping Up

This project was a deep dive into the full DevOps lifecycle, covering containerization, cloud infrastructure, Kubernetes deployments, and observability. Each part was built with a focus on security, efficiency, and automation.

**Key Takeaways**:
- **Security**: Implemented non-root users in containers, secure AWS setups with Terraform, and secure Kubernetes configurations.
- **Efficiency**: Used multi-stage builds in Docker, lightweight base images, and set up resource management in Kubernetes.
- **Automation**: Fully automated infrastructure provisioning and application deployment using Terraform and GitHub Actions.
- **Scalability**: Leveraged Kubernetes and Helm for easy scaling and management of the applications.

**What Could Be Improved**:
- **Secrets Management**: Integrating AWS Secrets Manager or Kubernetes Secrets would further enhance security.
- **Logging and Alerting**: Setting up centralized logging and alerting could provide even better observability.
- **Testing**: Incorporating automated testing into the CI/CD pipeline would add an extra layer of reliability.

Overall, this implementation is a solid foundation for deploying scalable, secure, and observable cloud-native applications.