# AWS Cloud Labs Portfolio

This repository contains hands-on AWS cloud labs demonstrating serverless, event-driven, and cloud-native architectures.

Each lab is built to showcase real-world AWS skills, IAM security, and production-style workflows.

---

## 🚀 Labs

### 🧪 Lab 1: S3-Triggered Lambda Logging

**Description:**  
An AWS Lambda function automatically triggers when a file is uploaded to an S3 bucket and logs the filename to CloudWatch.

**Services Used:**

- Amazon S3
- AWS Lambda
- IAM
- CloudWatch
- Python

📂 [View Lab 1](./lab1_s3_process)

---

## 🧠 Skills Demonstrated

- Serverless architecture
- Event-driven design
- IAM roles and permissions
- AWS logging and monitoring
- Python for cloud automation

---

### 🧪 Lab 2: Lambda Writing to DynamoDB

**Description:**  
An AWS Lambda function writes items to a DynamoDB table, demonstrating serverless data persistence and IAM-controlled access.

**Services Used:**

- AWS Lambda
- Amazon DynamoDB
- IAM
- CloudWatch
- Python

📂 [View Lab 2](./lab2_dynamodb_lambda)

---

### 🧪 Lab 3: API Gateway to DynamoDB

**Description:**  
An API Gateway HTTP API triggers a Lambda function that writes data to a DynamoDB table, demonstrating a serverless REST-style backend.

**Services Used:**

- Amazon API Gateway (HTTP API)
- AWS Lambda
- Amazon DynamoDB
- IAM
- CloudWatch
- Python

📂 [View Lab 3](./lab3_api_lambda_dynamodb)

---

### 🧪 Lab 4: Terraform Application Load Balancer Architecture

**Description:**  
Provisioned a highly available web application infrastructure using Terraform. This lab deploys a custom VPC, public subnets across multiple Availability Zones, EC2 instances running Apache, and an Application Load Balancer distributing traffic across targets.

This project demonstrates Infrastructure as Code (IaC), AWS networking, and scalable web architecture design.

**Services Used:**

- Amazon VPC
- Subnets (Multi-AZ)
- Internet Gateway
- Route Tables
- EC2
- Application Load Balancer (ALB)
- Target Groups
- Security Groups
- S3
- Terraform

📂 [View Lab 4](./lab4_terraform_alb)

---

## 🧠 Skills Demonstrated

- Serverless architecture
- Event-driven design
- IAM roles and permissions
- AWS logging and monitoring
- Python for cloud automation
- Infrastructure as Code (Terraform)
- AWS networking architecture
- Load balancing and high availability
- Multi-instance deployment
- Security group design
- Cloud architecture diagramming

## 🎯 Purpose

This repository serves as a **cloud engineering portfolio** to demonstrate practical AWS experience to recruiters and hiring managers.
