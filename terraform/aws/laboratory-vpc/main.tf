locals {
  # Define common CIDR blocks
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"

  # Define common names
  vpc_name                = "laboratory-dev"
  public_subnet_name      = "public-subnet"
  private_subnet_name     = "private-subnet"
  igw_name                = "laboratory-dev-igw"
  public_route_table_name = "laboratory-dev-public-route-table"
  security_group_name     = "laboratory-dev-sg"
  ec2_instance_name       = "laboratory-dev-ec2"

  # Define common tags
  common_tags = {
    Environment = "dev"
    Project     = "tlaboratory-dev-vpc"
  }
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr

  tags = merge(local.common_tags, {
    Name = local.vpc_name
  })
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = local.public_subnet_name
  })
}

# Create a private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_subnet_cidr

  tags = merge(local.common_tags, {
    Name = local.private_subnet_name
  })
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = local.igw_name
  })
}

# Create a route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(local.common_tags, {
    Name = local.public_route_table_name
  })
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create a security group
resource "aws_security_group" "laboratory_dev_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = local.security_group_name
  })
}

# Create an EC2 instance with specific storage size
resource "aws_instance" "laboratory_dev_ec2_instance" {
  ami                         = "ami-012c2e8e24e2ae21d" # Replace with your desired AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.laboratory_dev_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100    # Specify the desired storage size in GB
    volume_type = "gp2" # General Purpose SSD
  }

  tags = merge(local.common_tags, {
    Name = local.ec2_instance_name
  })

  key_name = "laboratory_dev" # Replace with your key pair name
}