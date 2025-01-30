# AWS Kinesis, Glue, and Athena Data Pipeline with Terraform

## Overview
This project sets up a **data pipeline** using **AWS Kinesis, AWS Glue, and Amazon Athena**, automated with **Terraform**. The pipeline ingests streaming data into Kinesis, processes it using Glue, and queries it efficiently with Athena.

## Features
- **AWS Kinesis**: Captures real-time data streams.
- **AWS Glue**: Processes and transforms data.
- **Amazon Athena**: Queries processed data using SQL.
- **Terraform**: Infrastructure as Code (IaC) for deployment automation.
- **S3 Integration**: Stores raw and processed data.
- **IAM Roles & Policies**: Secure access and permissions.

## Architecture
1. **Kinesis Data Stream** receives real-time data.
2. **AWS Glue Job** extracts, transforms, and loads (ETL) data.
3. **Transformed Data** is stored in an **S3 bucket**.
4. **AWS Glue Data Catalog** registers table metadata.
5. **Athena Queries** analyze the processed data.

## Prerequisites
- AWS Account with necessary permissions
- Terraform installed (`>= 1.0`)
- AWS CLI configured with valid credentials

## Setup Instructions
### 1️⃣ Clone the Repository
```bash
git clone <repository-url>
cd <repository-name>
```

### 2️⃣ Initialize Terraform
```bash
terraform init
```

### 3️⃣ Plan Deployment
```bash
terraform plan
```

### 4️⃣ Apply Changes
```bash
terraform apply -auto-approve
```

### 5️⃣ Validate the Setup
- **Kinesis Stream**: Send test data using AWS CLI.
- **Glue Jobs**: Check job execution logs in AWS Glue Console.
- **Athena Queries**: Run queries in the Athena console.

## Cleanup
To destroy the infrastructure:
```bash
terraform destroy -auto-approve
```

## Future Enhancements
- **Implement Monitoring** with AWS CloudWatch.

