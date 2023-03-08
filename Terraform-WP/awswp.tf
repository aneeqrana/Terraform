# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an EC2 instance
resource "aws_instance" "wp-example" {
  ami           = "ami-006dcf34c09e50022"
  instance_type = "t2.micro"
  key_name      = "devops"
  vpc_security_group_ids = [
    "sg-0ac4712014931ec78",
  ]

  # Use user data to install Docker and start a WordPress container
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y docker
              systemctl enable docker
              systemctl start docker
              docker run -d -p 80:80 --name wordpress -e WORDPRESS_DB_HOST= db:3306 -e WORDPRESS_DB_USER= aneeq -e WORDPRESS_DB_PASSWORD= aneeq123 -e WORDPRESS_DB_NAME= aneeq wordpress
              EOF
}

# Create a security group to allow HTTP and SSH traffic
resource "aws_security_group" "wordpress" {
  name_prefix = "wordpress-"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
