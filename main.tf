provider "aws" {
    region = var.region[0]
}

//Create a VPC
resource "aws_vpc" "terra-vpc" {
    cidr_block = var.cidr_blocks[0]
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name: "${var.env_prefix}-vpc"
    }
}

//Define the subnet module
module "terra-subnet" {
  source = "./modules/subnets"
  cidr_blocks = var.cidr_blocks
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.terra-vpc.id
  default_route = var.default_route
  default_route_table_id = aws_vpc.terra-vpc.default_route_table_id
}

//Define the webserver module
module "terra-ec2" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.terra-vpc.id
  subnet_id = module.terra-subnet.subnet-1.id
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  image_name = var.image_name
  public_key = var.public_key
  instance_type = var.instance_type
  my_ip = var.my_ip
  default_route = var.default_route
}