## Deployment Steps
This section will guide you through deploying the CloudFormation templates and managing the Lambda function.

### Step 1: Prepare the AWS Environment
#### 1. Install AWS CLI (if not already installed):

Follow the AWS CLI installation guide for your operating system.
Once installed, configure the CLI with your credentials using:
`aws configure`

#### 2. Ensure Necessary IAM Permissions:

Make sure the AWS user or role you are using has the following permissions:
- CloudFormationFullAccess
- LambdaFullAccess
- EC2FullAccess
- IAMFullAccess
- EventsFullAccess

### Step 2: Upload the Lambda Function Code
#### 1. Create the Python Lambda Function:

Save the Python script lambda_function.py. This script will stop or start EC2 instances based on the CloudWatch Events input.

#### 2. Create the Lambda Deployment Package:

- Zip the lambda_function.py file:
```
zip lambda_function_payload.zip lambda_function.py
```
#### 3. Upload the Zip File to an S3 Bucket (if you want to use S3):

If you're using S3, upload the `lambda_function_payload.zip` file to an S3 bucket:
```
aws s3 cp lambda_function_payload.zip s3://your-bucket-name/
```
### Step 3: Deploy the CloudFormation Templates
#### 1. Upload Templates:

- Upload the following YAML files to a folder in your system:
  - lambda_function.yaml
  - iam_roles.yaml
  - cloudwatch_events.yaml
  - (Optional) optional_ec2_instances.yaml (if you want to create EC2 instances for testing)
#### 2. Deploy the Lambda and IAM Roles:

- Run the following command to create the Lambda function and IAM roles:
```
aws cloudformation create-stack --stack-name lambda-ec2-scheduler --template-body file://lambda_function.yaml --capabilities CAPABILITY_NAMED_IAM
```
#### 4. Deploy CloudWatch Events:

- After the Lambda stack is created, deploy the CloudWatch Events:
```
aws cloudformation create-stack --stack-name cloudwatch-events-scheduler --template-body file://cloudwatch_events.yaml --capabilities CAPABILITY_NAMED_IAM
```
#### 4. (Optional) Deploy EC2 Instances:
- If you want to create EC2 instances for testing, deploy the EC2 instances stack:
```
aws cloudformation create-stack --stack-name ec2-scheduler-instances --template-body file://optional_ec2_instances.yaml --parameters ParameterKey=VpcId,ParameterValue=<your-vpc-id> ParameterKey=SubnetId,ParameterValue=<your-subnet-id> ParameterKey=InstanceType,ParameterValue=t2.micro ParameterKey=KeyName,ParameterValue=<your-key-name> ParameterKey=AmiId,ParameterValue=<your-ami-id>
```
### Step 4: Verify the Deployment
#### 1. Check Lambda Function:

- In the AWS Management Console, navigate to Lambda and verify that the start-stop-ec2-tagged Lambda function was created.
- Check the IAM roles and CloudWatch Event rules as well.
#### 2. Test CloudWatch Triggers:

- Verify that CloudWatch triggers are set up to invoke the Lambda function at the correct times.
- You can manually trigger the Lambda function from the AWS Console to ensure it starts or stops the EC2 instances as expected.
### Step 5: Cleanup (Optional)
- If you need to delete the CloudFormation stacks and resources:
```
aws cloudformation delete-stack --stack-name lambda-ec2-scheduler
aws cloudformation delete-stack --stack-name cloudwatch-events-scheduler
aws cloudformation delete-stack --stack-name ec2-scheduler-instances
```
