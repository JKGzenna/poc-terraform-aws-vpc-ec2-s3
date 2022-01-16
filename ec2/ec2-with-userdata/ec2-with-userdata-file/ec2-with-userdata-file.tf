provider "aws" {
  region = "eu-west-1"
}

variable "key_name" {
}

resource "aws_instance" "microsites_server" {
  ami = "ami-0aef57767f5404a3c"
  instance_type = "t2.micro"
  key_name = var.key_name

  user_data = "${file("userdata.sh")}"

  security_groups = [
    "${aws_security_group.allow_http.name}"
  ]

  tags = {
    Name = "Microsites Server"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_all_http_ssh"
  description = "Allow all HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_http_ssh"
  }
}

output "ipaddress" {
  value= "${aws_instance.microsites_server.public_dns}"
}
