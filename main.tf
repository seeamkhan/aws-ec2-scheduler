# Specify the AWS provider
provider "aws" {
  region = var.aws_region
}

# Data source to fetch a default subnet in any availability zone
data "aws_subnet" "default" {
  default_for_az = true
}

# Use an existing security group and using the default subnet
resource "aws_instance" "ec2_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # Associate public IP via network_interface
  network_interface {
    network_interface_id = aws_network_interface.example.id
    device_index         = 0
  }

  user_data = file("user_data.sh")

  tags = {
    Name      = "Instance ${count.index + 1}"
    scheduler = var.scheduler[count.index]
  }

  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  private_dns_name_options {
    hostname_type                     = "ip-name"
    enable_resource_name_dns_a_record = true
    enable_resource_name_dns_aaaa_record = false
  }
}

# Network Interface (referencing existing security group)
resource "aws_network_interface" "example" {
  subnet_id       = data.aws_subnet.default.id
  private_ips     = [var.private_ip]
  security_groups = [var.existing_security_group_id]
}
