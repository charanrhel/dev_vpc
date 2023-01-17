/* terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.50.0"
    }
  }
} */

data "aws_availability_zones" "available" {
  state = "available"
}
# VPC creation
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "192.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "dev_vpc"

  }
}

# Internet Gateway

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

#Subnets

resource "aws_subnet" "dev_public" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = element(var.pub_cidr, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = "true"

  tags = {
    Name = "dev_public_${count.index + 1}_subnet"
  }
}

resource "aws_subnet" "dev_private" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = element(var.priv_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "dev_private_${count.index + 1}_subnet"
  }
}

resource "aws_subnet" "dev_data" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = element(var.data_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "dev_data_${count.index + 1}_subnet"
  }
}
#nat_gateway
resource "aws_eip" "dev_eip" {
  vpc = "true"

  tags = {
    Name = "dev_eip"
  }

}
resource "aws_nat_gateway" "dev_nat" {
  allocation_id = aws_eip.dev_eip.id
  subnet_id     = aws_subnet.dev_public[1].id

  tags = {
    Name = "dev_nat-gateway"
  }
  depends_on = [
    aws_eip.dev_eip
  ]
}

#route_table

resource "aws_route_table" "dev_public" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    Name = "dev_public_route"
  }
}

resource "aws_route_table" "dev_private" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_nat.id
  }

  tags = {
    Name = "dev_private_route"
  }
}

#route table association

resource "aws_route_table_association" "dev_public" {
  count          = length(aws_subnet.dev_public[*].id)
  route_table_id = aws_route_table.dev_public.id
  subnet_id      = element(aws_subnet.dev_public[*].id, count.index)

}
resource "aws_route_table_association" "dev_private" {
  count          = length(aws_subnet.dev_public[*].id)
  route_table_id = aws_route_table.dev_private.id
  subnet_id      = element(aws_subnet.dev_private[*].id, count.index)

}
resource "aws_route_table_association" "dev_data" {
  count          = length(aws_subnet.dev_public[*].id)
  route_table_id = aws_route_table.dev_private.id
  subnet_id      = element(aws_subnet.dev_data[*].id, count.index)

}  