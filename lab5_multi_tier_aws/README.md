````markdown
# AWS Lab 5 — Terraform Multi-Tier AWS Architecture

## What this does

This lab provisions a **complete multi-tier AWS architecture using Terraform**.

Instead of manually building resources inside the AWS Console, all infrastructure is defined as code and deployed automatically using Infrastructure as Code (IaC).

A public Application Load Balancer distributes traffic across EC2 application servers running inside private subnets, while an Amazon RDS PostgreSQL database provides the backend database layer.

---

## Architecture

Internet → Application Load Balancer → EC2 Application Tier → PostgreSQL RDS Database → Private AWS Network

Terraform creates:

- Custom VPC
- Public subnets in **two Availability Zones**
- Private application subnets
- Private database subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Application Load Balancer
- Target Group + Listener
- EC2 Application Servers
- PostgreSQL RDS Database
- Security Groups
- Terraform Variables + Outputs

---

## Technologies Used

- Terraform
- AWS VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Application Load Balancer (ALB)
- AWS EC2
- Amazon RDS (PostgreSQL)
- Security Groups
- Python Diagrams Library

---

## What this proves

- Infrastructure as Code (IaC)
- AWS networking fundamentals
- Multi-tier cloud architecture design
- Terraform resource management
- Secure AWS networking practices
- Load balancing concepts
- Database deployment in AWS
- Multi-AZ infrastructure deployment
- Cloud documentation and architecture visualization

---

## Screenshots (Proof of Work)

### 1. Terraform Apply Successful

![](screenshots/1-terraform-apply.png)

### 2. VPC & Networking Resources Created

![](screenshots/2-vpc-networking.png)

### 3. EC2 Application Tier Running

![](screenshots/3-ec2-running.png)

### 4. Application Load Balancer Created

![](screenshots/4-alb-created.png)

### 5. Target Group Healthy

![](screenshots/5-target-group-healthy.png)

### 6. PostgreSQL RDS Database Created

![](screenshots/6-rds-created.png)

### 7. Browser Access Through Load Balancer

![](screenshots/7-browser-working.png)

### 8. Architecture Diagram

![](screenshots/8-lab-5-aws-architecture.png)

---

## Architecture Diagram

This project uses **Python's Diagrams library** to generate infrastructure diagrams directly from architectural design.

Diagram source code included:

```plaintext
lab5_diagram.py
```
````

---

## Future Improvements

Potential next improvements:

- Terraform Modules
- Auto Scaling Group (ASG)
- Launch Templates
- HTTPS / SSL Certificates
- Route53 DNS Integration
- CI/CD Pipeline Deployment
- CloudWatch Monitoring & Alerts

---

```

```
