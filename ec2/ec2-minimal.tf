provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "microsites_server" {
  ami = "ami-0aef57767f5404a3c"
  instance_type = "t2.micro"
}
