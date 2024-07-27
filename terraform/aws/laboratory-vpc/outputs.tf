# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output the public subnet ID
output "public_subnet_id" {
  value = aws_subnet.public.id
}

# Output the private subnet ID
output "private_subnet_id" {
  value = aws_subnet.private.id
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}
