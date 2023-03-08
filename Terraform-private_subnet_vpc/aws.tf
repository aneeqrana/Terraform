provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.example.id
}

resource "aws_security_group" "example" {
  name_prefix = "example"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.example.id
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99" // Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "devops"
  subnet_id     = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y docker
              systemctl enable docker
              systemctl start docker
              docker run -p 80:80 node:latest /bin/sh -c "echo 'Hello, World!' > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"
              EOF
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
