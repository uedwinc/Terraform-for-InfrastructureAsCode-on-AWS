//Create a security group
resource "aws_security_group" "terra-sg" {
  name = "terra-sg"
  description = "Allow SSH and HTTP Traffic to EC2 Instance on port 22 and 8080"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH to EC2"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
    prefix_list_ids = []
    ipv6_cidr_blocks = []
  }
  ingress {
    description = "HTTP on port 8080"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [var.default_route]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" //-1 in protocol definition means all traffic
    cidr_blocks = [var.default_route]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
  }
  tags = {
    Name: "${var.env_prefix}-sg"
  }
}

//Filter latest version of AMI
data "aws_ami" "latest-amazon-linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
}

//Create key pair with system ssh key
resource "aws_key_pair" "terra-key" {
  key_name = "terra-key"
  public_key = file(var.public_key) // Use var.public_key if you pasted the key values directly in tfvars.
}

//Create an EC2 instance
resource "aws_instance" "terra-ec2-server" {
  ami = data.aws_ami.latest-amazon-linux.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.terra-sg.id]
  availability_zone = var.avail_zone[0] //This must match the subnet availability zone
  associate_public_ip_address = true
  key_name = aws_key_pair.terra-key.key_name //You can reference an already available key pair name here if you have access to aws console
  
  //We'll use user-data parameter to deploy a docker container in the ec2 instance
  user_data = file("docker-script.sh")

  tags = {
    Name: "${var.env_prefix}-ec2-server"
  }
}