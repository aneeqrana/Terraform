provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "example" {
  name_prefix = "example"

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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-086b3de06dafe36c5"
  instance_type = "t2.micro"
  key_name      = "billease"
  vpc_security_group_ids = [
    aws_security_group.example.id,
  ]
  user_data = <<-EOF
              #!/bin/bash
              yum install -y docker
              systemctl enable docker
              systemctl start docker
              sudo chown $USER /var/run/docker.sock
              docker run -p 80:80 -d nginx
              EOF
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
