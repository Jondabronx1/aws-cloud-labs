# 🧪 AWS Lab 3 — API Gateway to DynamoDB

## What this does

An AWS API Gateway HTTP API triggers a Lambda function that writes data to a DynamoDB table.  
This lab demonstrates a serverless REST-style backend using managed AWS services.

---

## Architecture

Client → API Gateway → Lambda → DynamoDB → CloudWatch

---

## Technologies Used

- Amazon API Gateway (HTTP API)
- AWS Lambda
- Amazon DynamoDB
- IAM
- Python
- CloudWatch

---

## What this proves

- Serverless backend development
- REST API integration with Lambda
- NoSQL database operations using DynamoDB
- IAM permissions and least-privilege access
- Event-driven cloud architecture
- Monitoring and debugging with CloudWatch
- API testing using curl

---

## Screenshots (Proof of Work)

### 1. DynamoDB Table Created

![](screenshots/1-dynamodb-table.png)

### 2. Lambda Function Created

![](screenshots/2-lambda-created.png)

### 3. Lambda Test

![](screenshots/3-lambda-test-success.png)

### 4. Dynamodb Item

![](screenshots/4-dynamodb-item.png)

### 5. API Gateway Route

![](screenshots/5-api-gateway-route.png)

### 6. Sucessful Curl Command and Response

![](screenshots/6-successful-curl-command.png)

### 7. New Item in Dynamodb Table

![](screenshots/7-new-item-in-dynamodb.png)

### 8. CloudWatch Log

![](screenshots/8-cloudwatch-log.png)
