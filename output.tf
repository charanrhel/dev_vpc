output "Available_zones" {
  value = data.aws_availability_zones.available.names
}

output "igw" {
  value = aws_internet_gateway.dev_igw.arn
}

output "nat-gw" {
  value = aws_nat_gateway.dev_nat.connectivity_type
  // value = aws_nat_gateway.dev_nat.arn
}
