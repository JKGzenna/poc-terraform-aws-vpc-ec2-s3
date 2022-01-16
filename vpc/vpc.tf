provider "aws" {
  region = "eu-west-1"
}

#variable "ec2-key" {}

variable "ami"{
    default="ami-0aef57767f5404a3c"
}

resource "aws_vpc" "microsites_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Microsites VPC"
  }
}

resource "aws_internet_gateway" "gtw_web_internet" {
  vpc_id = aws_vpc.microsites_vpc.id

  tags = {
    Name = "Gateway Web Internet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.microsites_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private Subnet 10.0.1.0/24"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.microsites_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Public Subnet 10.0.2.0/24"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.microsites_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw_web_internet.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_all_ssh"
  description = "Allow all inbound ssh traffic "

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_ssh"
  }
}

resource "aws_instance" "web_server" {
  ami = var.ami
  instance_type = "t2.micro"
  #key_name = var.ec2-key
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]

  tags = {
    Name = "Microsites EC2 Server"
  }
}
