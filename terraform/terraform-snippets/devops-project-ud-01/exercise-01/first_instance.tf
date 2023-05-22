provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "intro" {
  ami                    = "ami-0889a44b331db0194"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "dove-key"
  vpc_security_group_ids = ["sg-0b570d130b0b4ca23"]
  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }
}