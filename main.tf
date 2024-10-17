# Specify the AWS provider
provider "aws" {
  region = var.aws_region
}

# Data source to list all subnets in the specified VPC
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Ensure there's at least one subnet before proceeding
data "aws_subnet" "default" {
  count = length(data.aws_subnets.all.ids) > 0 ? 1 : 0
  id    = data.aws_subnets.all.ids[0] # Selects the first subnet from the list
}

# Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_filename)
}

# Network Interface (referencing existing security group)
resource "aws_network_interface" "example" {
  count           = var.instance_count
  subnet_id       = data.aws_subnet.default[0].id # Use the first subnet if available
  security_groups = [var.existing_security_group_id]
}

# Use an existing security group and the default subnet
resource "aws_instance" "ec2_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # Associate public IP via network_interface
  network_interface {
    network_interface_id = aws_network_interface.example[count.index].id # Reference each network interface
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
    hostname_type                        = "ip-name"
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
  }
}
