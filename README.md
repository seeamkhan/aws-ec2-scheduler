# AWS EC2 Scheduler with Lambda Automation

## Overview

This project demonstrates how to:

1. Create EC2 instances with a custom tag `scheduler` set to `true` or `false`.
2. Use AWS Lambda to auto start/stop EC2 instances with the `scheduler=true` tag based on a schedule.
3. Set up necessary IAM roles for Lambda and CloudWatch events to trigger based on schedule.

## How to Use

### Step 1: Clone the Project

```bash
git clone https://github.com/your-repo/aws-ec2-scheduler.git
cd aws-ec2-scheduler
```

### Step 2: Update Variables
Rename the terraform.tfvars.example to terraform.tfvars:
```bash
mv terraform.tfvars.example terraform.tfvars
```
Then, update terraform.tfvars with your desired values (e.g., instance type, count, etc.).

### Step 3: Apply the Configuration
You can apply resources in two ways:

#### Option 1: Apply All Resources
```bash
terraform init
terraform apply
```

#### Option 2: Apply Targeted Resources
Apply specific resources using targeted commands. Example to create EC2 instances:
```bash
terraform apply -target=aws_instance.my_instance
```
For more commands, refer to the `targeted-commands` file.

## Components
- EC2 Instances: Instances with the scheduler=true tag are managed by Lambda.
- Lambda Function: Starts/stops EC2 instances based on the tag.
- IAM Role: Grants Lambda permission to manage EC2 instances.
- CloudWatch Events: Triggers Lambda based on a schedule.
## Clean Up
To destroy all resources:
```bash
terraform destroy
```
##  
Enjoy automating your EC2 instances! 🚀
