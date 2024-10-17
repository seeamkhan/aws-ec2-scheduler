#!/bin/bash
# Use this script for EC2 user data

# Update and install HTTP server (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Add custom HTML page
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
