aws_region       = "us-east-1" # Replace with your preferred region
key_name         = "EC2 Tutorial" # Replace with your AWS key pair name
ami_id           = "ami-06b21ccaeff8cd686" # Replace with the correct AMI ID for your region
instance_type    = "t2.micro" # Free Tier eligible instance type
instance_count   = 3 # Number of instances to create

# Scheduler tag values for instances
scheduler = ["true", "true", "false"] # Adjust values as needed

subnet_id        = "subnet-XXXXXXX" # Replace with your subnet ID
private_ip       = "10.0.1.10" # Example private IP, adjust as necessary
existing_security_group_id = "sg-0ffab33cddc848b73" # Your existing security group ID from the Console-to-Code
