//Create a subnet and associate it with the VPC
resource "aws_subnet" "terra-subnet-1" {
    vpc_id = var.vpc_id
    cidr_block = var.cidr_blocks[1]
    availability_zone = var.avail_zone[0]
    tags = {
      Name: "${var.env_prefix}-subnet-1"
    }
}

//Create a second subnet and associate it with the VPC
resource "aws_subnet" "terra-subnet-2" {
    vpc_id = var.vpc_id
    cidr_block = var.cidr_blocks[2]
    availability_zone = var.avail_zone[1]
    tags = {
      Name: "${var.env_prefix}-subnet-2"
    }
}

//Call up the default route table created alongside the VPC
//This is only necessary because we want to associate one of the subnets to it
resource "aws_default_route_table" "terra-default-route-table" {
  default_route_table_id = var.default_route_table_id
  tags = {
    Name: "${var.env_prefix}-default-rtb"
  }
}

//Create a custom route table and associate it with the VPC
resource "aws_route_table" "terra-route-table" {
  vpc_id = var.vpc_id
  tags = {
    Name: "${var.env_prefix}-custom-rtb"
  }
}

//Associate subnet-1 to the custom route table
resource "aws_route_table_association" "rtb-subnet-1" {
  subnet_id = aws_subnet.terra-subnet-1.id
  route_table_id = aws_route_table.terra-route-table.id
}

//Associate subnet-2 to the default route table
resource "aws_route_table_association" "default-rtb-subnet-2" {
  subnet_id = aws_subnet.terra-subnet-2.id
  route_table_id = aws_default_route_table.terra-default-route-table.id
}

//Create an internet gateway and associate it with the VPC
resource "aws_internet_gateway" "terra-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

//Create a route to the internet gateway for custom route table
resource "aws_route" "custom-rtb-igw" {
  route_table_id = aws_route_table.terra-route-table.id
  destination_cidr_block = var.default_route
  gateway_id = aws_internet_gateway.terra-igw.id
}

//Create a route to the internet gateway for default route table
resource "aws_route" "default-rtb-igw" {
  route_table_id = aws_default_route_table.terra-default-route-table.id
  destination_cidr_block = var.default_route
  gateway_id = aws_internet_gateway.terra-igw.id
}